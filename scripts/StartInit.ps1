[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$ResourcesDirectory,

    [Parameter(Mandatory)]
    [string]$SqlServer,

    [Parameter(Mandatory)]
    [string]$SqlAdminUser,

    [Parameter(Mandatory)]
    [string]$SqlAdminPassword,

    [Parameter(Mandatory)]
    [string]$SitecoreAdminUser,

    [Parameter(Mandatory)]
    [string]$SitecoreAdminPassword,

    [string]$SitecoreAdminEnhancedHashAlgorithm,

    [string]$SqlElasticPoolName,

    [string]$DatabasesToDeploy,

    [string]$DatabasesToExclude,

    [string]$DatabasesEnableContainment,

    [string]$DatabasesScripts,

    [string]$SecurityDatabase,

    [int]$PostDeploymentWaitPeriod,

    [Parameter(Mandatory)]
    [object[]]$DatabaseUsers
)
begin {
    function ConvertFrom-Json {
        [CmdletBinding()]
        param ([Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)] [string] $InputObject, [switch] $AsHashtable)
        begin {
            # https://4sysops.com/archives/convert-json-to-a-powershell-hash-table/
            function ConvertTo-Hashtable {
                [CmdletBinding()]
                [OutputType('hashtable')]
                param ([Parameter(ValueFromPipeline)] $InputObject)
                process {
                    if ($null -eq $InputObject) { return $null }
                    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
                        $collection = @(
                            foreach ($object in $InputObject) {
                                ConvertTo-Hashtable -InputObject $object
                            }
                        )
                        Write-Output -NoEnumerate $collection
                    }
                    elseif ($InputObject -is [psobject]) {
                        $hash = @{}
                        foreach ($property in $InputObject.PSObject.Properties) {
                            $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
                        }
                        Write-Output $hash
                    }
                    else {
                        Write-Output $InputObject
                    }
                }
            }
        }
        process {
            if ($PSEdition -eq 'Core') {
                Write-Output ($InputObject | Microsoft.PowerShell.Utility\ConvertFrom-Json -AsHashtable:$AsHashtable)
            }
            elseif ($AsHashtable) {
                Write-Output ($InputObject | Microsoft.PowerShell.Utility\ConvertFrom-Json | ConvertTo-Hashtable)
            }
            else {
                Write-Output ($InputObject | Microsoft.PowerShell.Utility\ConvertFrom-Json)
            }
        }
    }

    function Merge-DatabasesFiles {
        [CmdletBinding()]
        param ([string]$Path, [string[]]$DatabasesToExclude, [object[]]$DatabaseUsers, [string]$SitecoreAdminUser, [string]$SitecoreAdminPassword, [switch]$SitecoreAdminEnhancedHashAlgorithm, [switch]$SecurityDatabase)
        process {
            # combine all databases.json files
            Write-Information -Message ("`nConfiguration File: {0}" -F ($databaseFile = Join-Path -Path $Path -ChildPath 'databases.json'))
            $databases = Get-Content -LiteralPath $databaseFile -Raw | ConvertFrom-Json -AsHashtable
            # NOTE: Get-ChildItem functionality differs between PWSH (PSEdition=Core) and PowerShell (PSEdition=Desktop). The " | Where-Object { $_.Name -eq 'databases.json' } " code segment is only required for "Desktop" edition compatibility
            foreach ($databaseFile in (Get-ChildItem -LiteralPath (Get-ChildItem -LiteralPath $Path -Directory -Recurse).FullName -Include 'databases.json') | Where-Object { $_.Name -eq 'databases.json' }) {
                if (($databaseFile.Directory.Name -eq 'sitecore_admin_user_security_hardening') -and (-not $SitecoreAdminEnhancedHashAlgorithm)) { continue }
                if (($databaseFile.Directory.Name -eq 'sitecore_security_database') -and (-not $SecurityDatabase)) { continue }
                Write-Information -Message ("- merged: {0}" -F $databaseFile.FullName)
                $moduleDatabases = Get-Content -LiteralPath $databaseFile.FullName -Raw | ConvertFrom-Json -AsHashtable
                foreach ($name in $moduleDatabases.Keys) {
                    if ($databases.ContainsKey($name)) {
                        foreach ($key in $moduleDatabases."$name".Keys) {
                            if ($databases."$name".ContainsKey($key)) {
                                switch -regex ($key) {
                                    '(shard_)?scripts' {
                                        foreach ($item in $moduleDatabases."$name"."$key") {
                                            if ($item -notmatch ':') { $item += ':' }
                                            if ($item -match '^\[\+\](?<item>.*)$') {
                                                # special '[+]' case that adds the script only if the same named script already exists (different parameters/values to be passed)
                                                $item = $matches['item']
                                                $filename = $item -replace (':.*$', '')
                                                if ($null -eq ($databases."$name"."$key" | Where-Object { $_ -match ('^{0}:' -F [regex]::Escape($filename)) })) {
                                                  $item = ''
                                                }
                                            }
                                            elseif ($item -match '^\[-\](?<item>.*)$') {
                                                # special '[-]' case that removes all existing scripts of the same name (regardless of modules folder location) but only if parameters are identical (required for 'sitecore_security_database')
                                                $item = $matches['item']
                                                $filenameAndParameters = $item -replace ('.+\\', '')
                                                if ($null -ne ($databases."$name"."$key" | Where-Object { ($_ -eq $filenameAndParameters) })) {
                                                    [string[]]$databases."$name"."$key" = ($databases."$name"."$key" | Where-Object { $_ -ne $filenameAndParameters })
                                                }
                                            }
                                            else {
                                                # remove all existing scripts of the same name (regardless of modules folder location)
                                                $filename = $item -replace (':.*$', '') -replace ('.+\\', '')
                                                if ($null -ne ($databases."$name"."$key" | Where-Object { $_ -match ('^{0}:' -F [regex]::Escape($filename)) })) {
                                                    [string[]]$databases."$name"."$key" = ($databases."$name"."$key" | Where-Object { $_ -notmatch "^${filename}:" })
                                                }
                                            }
                                            if ((-not [System.String]::IsNullOrEmpty($item)) -and ($databases."$name"."$key" -notcontains $item)) {
                                                [string[]]$databases."$name"."$key" += $item
                                            }
                                        }
                                    }
                                    'dacpacs' {
                                        foreach ($item in $moduleDatabases."$name"."$key") {
                                            if ($databases."$name"."$key" -notcontains $item) {
                                                $databases."$name"."$key" += $item
                                            }
                                        }
                                    }
                                    default {
                                        foreach ($item in $moduleDatabases."$name"."$key".Keys) {
                                            if ($databases."$name"."$key".ContainsKey($item)) {
                                                $databases."$name"."$key"."$item" = $moduleDatabases."$name"."$key"."$item"
                                            }
                                            else {
                                                $databases."$name"."$key".Add($item, $moduleDatabases."$name"."$key"."$item")
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                $databases."$name".Add($key, $moduleDatabases."$name"."$key")
                            }
                        }
                    }
                    else {
                        $databases.Add($name, $moduleDatabases."$name")
                    }
                }
            }

            # set database exclude flag (where specified)
            foreach ($name in $DatabasesToExclude) {
                if ($databases.ContainsKey($name)) {
                    if ($databases."$name".ContainsKey('exclude')) {
                        $databases."$name".exclude = 'true'
                    }
                    else {
                        $databases."$name".Add('exclude', 'true')
                    }
                }
            }

            # add database scripts variables (e.g. username, passwords) + optionally change database name
            foreach ($item in $DatabaseUsers) {
                $name = $item.name
                if ($databases.ContainsKey($name)) {
                    foreach ($key in ($item.Keys.ToLower() | Where-Object { $_ -ne 'name' })) {
                        [string]$value = $item.$key
                        if ($databases."$name".variables.ContainsKey($key)) {
                            if (-not [System.String]::IsNullOrEmpty($value)) { $databases."$name".variables."$key" = $value }
                        }
                        else {
                            $databases."$name".variables.Add($key, $value)
                        }
                    }
                }
            }

            # update Sitecore.Security database variables for sitecore administrator user
            $databases."Sitecore.Security".variables.sitecoreadminusername = $SitecoreAdminUser
            $databases."Sitecore.Security".variables.sitecoreadminpassword = $SitecoreAdminPassword

            Write-Output $databases
        }
    }

    function Fix-SingleQuotes {
        [CmdletBinding()]
        param ([string]$String)
        process {
            Write-Output ($String -replace ("'", "''"))
        }
    }

    function Invoke-SqlCmdQuery {
        [CmdletBinding()]
        param ([string]$SqlServer, [string]$SqlDatabase, [string]$SqlUser, [string]$SqlPassword, [string]$Query, [string] $Arguments)
        process {
            $sqlcmdArgs = (" -S '{0}'" -F $SqlServer)
            if ($SqlDatabase) {
                $sqlcmdArgs += (" -d '{0}'" -F $SqlDatabase)
            }
            if ($SqlUser -and $SqlPassword) {
                $sqlcmdArgs += (" -U '{0}' -P '{1}'" -F $SqlUser, (Fix-SingleQuotes -String $SqlPassword))
            }
            $sqlcmdArgs += ((" -Q ""{0}"" " -F $Query) + $Arguments).TrimEnd()
            Write-Information -Message ("sqlcmd" + (($sqlcmdArgs + ' ') -replace ((" -P '" + [regex]::Escape((Fix-SingleQuotes -String $SqlPassword)) + "' "), " -P '********' ") -replace ("Password='.+?'\s", "Password='********' ")  -replace ('\s*$', '')))
            Invoke-Expression ("sqlcmd.exe" + $sqlcmdArgs)
        }
    }

    function Invoke-SqlCmdFile {
        [CmdletBinding()]
        param ([string]$SqlServer, [string]$SqlDatabase, [string]$SqlUser, [string]$SqlPassword, [string]$File, [string] $Arguments)
        process {
            $sqlcmdArgs = (" -S '{0}'" -F $SqlServer)
            if ($SqlDatabase) {
                $sqlcmdArgs += (" -d '{0}'" -F $SqlDatabase)
            }
            if ($SqlUser -and $SqlPassword) {
                $sqlcmdArgs += (" -U '{0}' -P '{1}'" -F $SqlUser, (Fix-SingleQuotes -String $SqlPassword))
            }
            $sqlcmdArgs += ((" -i ""{0}"" " -F $File) + $Arguments).TrimEnd()
            Write-Information -Message ("sqlcmd" + (($sqlcmdArgs + ' ') -replace ((" -P '" + [regex]::Escape((Fix-SingleQuotes -String $SqlPassword)) + "' "), " -P '********' ") -replace ("Password='.+?'\s", "Password='********' ") -replace ('\s*$', '')))
            Invoke-Expression ("sqlcmd.exe" + $sqlcmdArgs)
        }
    }

    function Install-SqlScripts {
        [CmdletBinding()]
        param ([hashtable]$Databases, [string]$Name, [string[]]$Scripts, [string]$SqlServer, [string]$SqlDatabase, [string]$SqlAdminUser, [string]$SqlAdminPassword, [string]$Arguments)
        process {
            foreach ($sqlScript in $Scripts) {
                $sqlFile, $sqlVars, $varMissingMessage = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0]), (' ' + ($sqlScript -replace ('^[^:]+:', '')) + ' '), ''
                if (-not (Test-Path -Path $sqlFile -PathType Leaf)) {
                    Write-Warning -Message ("Script {0} not found [{1}]" -F $sqlFile, $name)
                    continue
                }
                (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                foreach ($var in ($sqlVars -replace ('\s[^=]+=', ' ')).Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)) {
                    if ($databases."$name".ContainsKey('variables') -and $databases."$name".variables.ContainsKey($var)) {
                        $value = $databases."$name".variables.$var -replace ('"', '""')
                        if ([System.String]::IsNullOrEmpty($value)) {
                            $varMissingMessage += (", {0}:{1}" -F $var, 'empty')
                            continue
                        }
                        $sqlVars = $sqlVars -replace ("=$var ", ("='" + (Fix-SingleQuotes -String $value) + "' "))
                    }
                    elseif ($databases."$name".ContainsKey('references') -and $databases."$name".references.ContainsKey($var)) {
                        if ($databases."$name".references.$var -notmatch '^(?<name>[^:]+):(?<variable>.+)$') {
                            $varMissingMessage += (", {0}:{1}" -F $var, 'bad-reference-association')
                            continue
                        }
                        $refName, $refVar = $matches['name'], $matches['variable']
                        if ($databases."$refName".ContainsKey('variables') -and $databases."$refName".variables.ContainsKey($refVar)) {
                            $value = $databases."$refName".variables.$refVar -replace ('"', '""')
                            if ([System.String]::IsNullOrEmpty($value)) {
                                $varMissingMessage += (", {0}:{1}" -F $var, 'empty-reference-association')
                                continue
                            }
                            $sqlVars = $sqlVars -replace ("=$var ", ("='" + (Fix-SingleQuotes -String $value) + "' "))
                        }
                        else {
                            $varMissingMessage += (", {0}:{1}" -F $var, 'invalid-reference-association')
                        }
                    }
                    else {
                        $varMissingMessage += (", {0}:{1}" -F $var, 'not-set')
                    }
                }
                $sqlVars = $sqlVars.Trim()
                if ([System.String]::IsNullOrEmpty($varMissingMessage)) {
                    if ([System.String]::IsNullOrEmpty($sqlVars)) {
                        Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $SqlDatabase -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments $Arguments.Trim()
                    }
                    else {
                        Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $SqlDatabase -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments ($Arguments.Trim() + " -v " + $sqlVars).Trim()
                    }
                    if ($LASTEXITCODE -ne 0) {
                        throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                    }
                }
                else {
                    Write-Warning -Message ("Script {0} has missing -DatabaseUsers variables ({2}) [{1}]" -F $sqlFile, $name, ($varMissingMessage -replace ('^, ', '')))
                }
                Remove-Item -LiteralPath $sqlFile -Force -ErrorAction SilentlyContinue
            }
        }
    }

}
process {
    Write-Information -Message ("`n{0}`n{1}: {2}`n{0}" -F ('=' * 70), 'DatabasesDeploymentStatus', 'Started')
    [System.Environment]::SetEnvironmentVariable('DatabasesDeploymentStatus', 'Started', 'Machine')
    $ResourcesDirectory = (Get-Item -Path $ResourcesDirectory).FullName
    $databases = Merge-DatabasesFiles -Path $ResourcesDirectory -SitecoreAdminUser $SitecoreAdminUser -SitecoreAdminPassword $SitecoreAdminPassword -SitecoreAdminEnhancedHashAlgorithm:($SitecoreAdminEnhancedHashAlgorithm -eq 'true') -SecurityDatabase:$($SecurityDatabase -eq 'true') -DatabasesToExclude $DatabasesToExclude.Split(',', [System.StringSplitOptions]::RemoveEmptyEntries) -DatabaseUsers $DatabaseUsers
    if ($env:DATABASES_JSON_INFORMATION) {
        Write-Information -Message (($databases | ConvertTo-Json | Out-String) -replace ('("(sitecoreadmin)?password[^"]*":\s+)"[^"]+"', '$1"********"'))
    }

    # validate against duplicated login (username attribute) with different passwords
    if ([System.String]::IsNullOrEmpty($DatabasesToDeploy)) {
        $sqlQuery = "SET NOCOUNT ON; SELECT SERVERPROPERTY('edition');"
        $sqlServerEdition = Invoke-SqlCmdQuery -SqlServer $SqlServer -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery -Arguments "-h -1 -W" -InformationAction SilentlyContinue
        if (($sqlServerEdition -ne 'SQL Azure') -and ($DatabasesEnableContainment -ne 'true')) {
            $usernames, $badLogin = @{}, @()
            foreach ($name in $databases.Keys) {
                foreach ($var in ($databases."$name".variables.Keys | Where-Object { $_ -match 'username' })) {
                    $var_password = $var -replace ('username', 'password')
                    if ((-not [System.String]::IsNullOrEmpty(($username = $databases."$name".variables.$var))) -and (-not [System.String]::IsNullOrEmpty(($password = $databases."$name".variables.$var_password)))) {
                        if ($usernames.ContainsKey($username)) {
                            if ($usernames."$username" -ne $password) {
                                if ($badLogin -notcontains $username) { $badLogin += $username }
                            }
                        }
                        else {
                            $usernames.Add($username, $password)
                        }
                    }
                }
            }
            if ($badLogin.Count -ne 0) {
                throw ('The same login specified by multiple databases contains different password values [{0}].' -F ($badLogin -join ', '))
            }
        }
    }

    & "$PSScriptRoot\DeployDatabases.ps1" -ResourcesDirectory $ResourcesDirectory -SqlElasticPoolName $SqlElasticPoolName -SqlServer $SqlServer -SqlAdminUser $SqlAdminUser -SqlAdminPassword $SqlAdminPassword -Databases $databases -DatabasesToDeploy $DatabasesToDeploy -EnableContainedDatabases:$($DatabasesEnableContainment -eq 'true') -SkipStartingServer

    if ([System.String]::IsNullOrEmpty($DatabasesToDeploy)) {
        # & "$PSScriptRoot\SetDatabaseUsers.ps1" -ResourcesDirectory $ResourcesDirectory -SqlServer $SqlServer -SqlAdminUser $SqlAdminUser -SqlAdminPassword $SqlAdminPassword -DatabaseUsers $DatabaseUsers
        foreach ($name in ($databases.Keys | Sort-Object)) {
            Write-Information -Message ("`n`n{0}`n{1}" -F ('-' * 70), $name)
            if (($databases."$name".exclude -eq 'true') -or (($name -eq 'Sitecore.Security') -and ($databases."Sitecore.Security".variables.databasename -eq $databases."Sitecore.Core".variables.databasename)) -or ($null -eq ($databaseName = $databases."$name".variables.databasename))) { continue }
            Install-SqlScripts -Databases $databases -Name $name -Scripts ($databases."$name".scripts | Where-Object { ($_ -match '^((createuser)|(createshard)).+\.sql:') -or ($_ -match '\\((createuser)|(createshard)).+\.sql:') }) -SqlServer $SqlServer -SqlDatabase $databaseName -SqlAdminUser $SqlAdminUser -SqlAdminPassword $SqlAdminPassword -Arguments "-b -V 11"
            if ($name -eq 'Sitecore.Xdb.Collection.ShardMapManager') {
                for ($shard = 0; $shard -lt [int]$databases."Sitecore.Xdb.Collection.ShardMapManager".variables.shardmax; $shard++) {
                    $databaseName = $databases."Sitecore.Xdb.Collection.ShardMapManager".variables.sharddatabasenameprefix + [string]$shard
                    Install-SqlScripts -Databases $databases -Name $name -Scripts ($databases."$name".shard_scripts | Where-Object { ($_ -match '^((createuser)|(createshard)).+\.sql:') -or ($_ -match '\\((createuser)|(createshard)).+\.sql:') }) -SqlServer $SqlServer -SqlDatabase $databaseName -SqlAdminUser $SqlAdminUser -SqlAdminPassword $SqlAdminPassword -Arguments "-b -V 11"
                }
            }
            if (-not [System.String]::IsNullOrEmpty($DatabasesScripts)) {
                Install-SqlScripts -Databases $databases -Name $name -Scripts ($databases."$name".scripts | Where-Object { ($_ -match ('^({0}).+\.sql:' -F $DatabasesScripts)) -or ($_ -match ('\\({0}).+\.sql:' -F $DatabasesScripts)) }) -SqlServer $SqlServer -SqlDatabase $databaseName -SqlAdminUser $SqlAdminUser -SqlAdminPassword $SqlAdminPassword -Arguments "-b -V 11"
            }
        }
        # & "$PSScriptRoot\SetSitecoreAdminPassword.ps1" -ResourcesDirectory $ResourcesDirectory -SqlServer $SqlServer -SqlAdminUser $SqlAdminUser -SqlAdminPassword $SqlAdminPassword -DatabaseUsers $DatabaseUsers
        Write-Information -Message ("`n`n{0}`n{1}" -F ('-' * 70), 'Sitecore.Security')
        Install-SqlScripts -Databases $databases -Name 'Sitecore.Security' -Scripts ($databases."Sitecore.Security".scripts | Where-Object { ($_ -match 'setsitecoreadminpassword\.sql:') }) -SqlServer $SqlServer -SqlDatabase $databases."Sitecore.Security".variables.databasename -SqlAdminUser $SqlAdminUser -SqlAdminPassword $SqlAdminPassword -Arguments "-b -V 11 -I"
    }

    Start-Sleep -Seconds $PostDeploymentWaitPeriod
    [System.Environment]::SetEnvironmentVariable('DatabasesDeploymentStatus', 'Completed', 'Machine')
    Write-Information -Message ("`n{0}`n{1}: {2}`n{0}" -F ('=' * 70), 'DatabasesDeploymentStatus', 'Completed')
}
