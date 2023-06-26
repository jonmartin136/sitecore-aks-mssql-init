[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$ResourcesDirectory,

    [string]$SqlElasticPoolName,

    [string]$SqlServer = "(local)",

    [string]$SqlAdminUser,

    [string]$SqlAdminPassword,

    [hashtable]$Databases,

    [string]$DatabasesToDeploy,

    [string]$DatabaseOwner,

    [switch]$EnableContainedDatabases,

    [switch]$SkipStartingServer
)
begin {
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

    function Add-SqlAzureConditionWrapper {
        [CmdletBinding()]
        param([string]$SqlQuery)
        process {
            return ("DECLARE @serverEdition nvarchar(256) = CONVERT(nvarchar(256), SERVERPROPERTY('edition'));
IF @serverEdition <> 'SQL Azure'
BEGIN
    {0}
END;
GO" -F $SqlQuery)
        }
    }

    $sqlPackageTool = "${env:ProgramFiles}\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"
    if (-not (Test-Path -Path $sqlPackageTool -PathType Leaf)) {
        throw ('{0}, file not found.' -F $sqlPackageTool)
    }

    $sqlQueryDatabaseOwner = "PRINT N'Changing database owner to [{0}]...';
    EXEC [dbo].[sp_changedbowner] '{0}';"

    $sqlQueryContainedDatabaseAuthentication = "DECLARE @containedAuthenticationEnabled int = CONVERT(int, (SELECT [value] FROM [sys].[configurations] WHERE [name] = 'contained database authentication'));
    IF @containedAuthenticationEnabled = 0
    BEGIN
        PRINT N'Enabling [contained database authentication]...';
        EXEC [sys].[sp_configure] N'contained database authentication', 1;
        EXEC ('RECONFIGURE');
    END;"

}
process {
    if (-not $SkipStartingServer){
        Start-Service -Name 'MSSQLSERVER'
    }

    if ($EnableContainedDatabases) {
        $sqlQuery = Add-SqlAzureConditionWrapper -SqlQuery $sqlQueryContainedDatabaseAuthentication
        Invoke-SqlCmdQuery -SqlServer $SqlServer -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery -Arguments "-b -V 11"
        if ($LASTEXITCODE -ne 0) {
            throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlQuery)
        }
    }

    $resourcesDirectories = @()
    if ([string]::IsNullOrEmpty($DatabasesToDeploy)) {
        $resourcesDirectories = @($ResourcesDirectory) + (Get-ChildItem -LiteralPath $ResourcesDirectory -Directory).FullName
    }
    else {
        foreach ($moduleDacpacsFolder in $DatabasesToDeploy.Split(',', [System.StringSplitOptions]::RemoveEmptyEntries)) {
            $modulesFolderPath = Join-Path $ResourcesDirectory -ChildPath $moduleDacpacsFolder
            if (($resourcesDirectories -notcontains $modulesFolderPath) -and (Test-Path -Path $modulesFolderPath -PathType Container)) {
                Write-Information -Message ("Adding dacpacs from {0} to deploy" -F $moduleDacpacsFolder)
                $resourcesDirectories += $modulesFolderPath
            }
            else {
                Write-Information -Message ("Folder with dacpacs for {0} does not exist" -F $moduleDacpacsFolder)
            }
        }
    }

    # list of databases for a specific dacpac files, e.g. Sitecore.Web.dacpac would be used for both the Web database and the Web Shared System database when using GeoReplication
    $dacpacsDatabases, $dacpacsDatabasesNameMap, $dacpacDatabasesCompatibilityLevel = @{}, @{}, @()
    foreach ($name in $Databases.Keys) {
        if (($Databases."$name".exclude -ne 'true') -and ($Databases."$name".ContainsKey('dacpacs'))) {
            $dacpacsDatabasesNameMap.Add($Databases."$name".variables.databasename, $name)
            foreach ($dacpac in $Databases."$name".dacpacs) {
                $dacpacName = $dacpac -replace ('^.+\\', '')
                if ($dacpacsDatabases.ContainsKey($dacpacName)) {
                    $dacpacsDatabases."$dacpacName" += $Databases."$name".variables.databasename
                }
                else {
                    $dacpacsDatabases.Add($dacpacName, @($Databases."$name".variables.databasename))
                }
            }
        }
    }

    $sqlQuery = "SET NOCOUNT ON; SELECT [name] FROM [sys].[databases];"
    $serverDatabasesCreated = @()
    $serverDatabases = Invoke-SqlCmdQuery -SqlServer $SqlServer -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery -Arguments "-b -V 11 -h -1 -W" -InformationAction SilentlyContinue
    if ($LASTEXITCODE -ne 0) {
        throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlQuery)
    }

    # Sitecore.* databases
    # NOTE: Get-ChildItem functionality differs between PWSH (PSEdition=Core) and PowerShell (PSEdition=Desktop). The "  | Where-Object { $_.Extension -eq '.dacpac' }" code segment is only required for "Desktop" edition compatibility
    foreach ($dacpac in (Get-ChildItem -LiteralPath $resourcesDirectories -Include '*.dacpac' -File) | Where-Object { $_.Extension -eq '.dacpac' }) {
        $dacpacFile, $dacpacFileName, $dacpacName = $dacpac.FullName, $dacpac.Name, $dacpac.BaseName
        if (($dacpacName -like '*Azure') -or (($dacpac.Directory.Name -eq 'collectiondeployment') -and $dacpacName  -eq 'Sitecore.Xdb.Collection.Database.Sql') -or ($dacpacName -like 'Sitecore.Xdb.Collection.Shard*')) {
            Write-Information -Message ("`n`n{0}`n{1}" -F ('-' * 70), $dacpacName)
            Write-Information -Message ("Skip {0}" -F $dacpacFileName)
            continue
        }

        if ((($dacpacName -eq 'Sitecore.Xdb.Collection.Database.Sql') -and ($Databases."Sitecore.Xdb.Collection.ShardMapManager".exclude -eq 'true')) -or ($Databases."$dacpacName".exclude -eq 'true')) {
            Write-Information -Message ("`n`n{0}`n{1}" -F ('-' * 70), $dacpacName)
            Write-Information -Message ("Skip {0} [excluded]" -F $dacpacFileName)
            continue
        }

        $databaseNames = @()
        if ($dacpacsDatabases."$dacpacFileName".Count -eq 0) {
            $databaseNames += $dacpacName
        }
        else {
            $databaseNames = $dacpacsDatabases."$dacpacFileName"
        }

        foreach ($databaseName in $databaseNames) {
            $name = $dacpacsDatabasesNameMap."$databaseName"
            Write-Information -Message ("`n`n{0}`n{1}" -F ('-' * 70), $name)

            if ([System.String]::IsNullOrEmpty($DatabasesToDeploy)) {
                if ($serverDatabases -contains $databaseName) {
                    if ([System.String]::IsNullOrEmpty($Databases."$name".variables.username)) {
                        Write-Information -Message ("Skip {0} for {1} [exists and no users specified - database schema already applied]" -F $dacpacFileName, $databaseName)
                        continue
                    }
                    $sqlQuery = "SET NOCOUNT ON; SELECT [name] FROM [sys].[database_principals] WHERE ([type] = 'S' AND [authentication_type] = 2) OR ([type] NOT IN ('R', 'S') AND [authentication_type] > 0 AND LEN([sid]) > 4 );"
                    $databaseUsers = Invoke-SqlCmdQuery -SqlServer $SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery -Arguments "-b -V 11 -h -1 -W"
                    if ($LASTEXITCODE -ne 0) {
                        throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlQuery)
                    }
                    if ($databaseUsers.Count -ne 0) {
                        Write-Information -Message ("Skip {0} for {1} [users exist - database schema already applied]" -F $dacpacFileName, $databaseName)
                        continue
                    }
                }
                elseif (($serverDatabasesCreated -notcontains $databaseName) -and ((-not [System.String]::IsNullOrEmpty($SqlElasticPoolName)) -and ($dacpacName -ne 'Sitecore.Xdb.Collection.Database.Sql'))) {
                    $sqlQuery = ("CREATE DATABASE [{0}] ( SERVICE_OBJECTIVE = ELASTIC_POOL ( name = [{1}] ));" -F $databaseName, $SqlElasticPoolName)
                    Invoke-SqlCmdQuery -SqlServer $SqlServer -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery -Arguments "-b -V 11"
                    if ($LASTEXITCODE -ne 0) {
                        throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlQuery)
                    }
                    $serverDatabasesCreated += $databaseName
                }
            }

            if ($dacpacName -eq 'Sitecore.Xdb.Collection.Database.Sql') {
                if (Test-Path -Path (Join-Path -Path $ResourcesDirectory -ChildPath 'collectiondeployment') -PathType Container) {
                    $shardNumber, $shardNamePrefix, $shardNameSuffix = $Databases."Sitecore.Xdb.Collection.ShardMapManager".variables.shardmax, $Databases."Sitecore.Xdb.Collection.ShardMapManager".variables.sharddatabasenameprefix, $Databases."Sitecore.Xdb.Collection.ShardMapManager".variables.sharddatabasenamesuffix
                    if ([System.String]::IsNullOrEmpty($shardNumber)) { $shardNumber = '2' }
                    if ([System.String]::IsNullOrEmpty($shardNamePrefix)) { $shardNamePrefix = 'Sitecore.Xdb.Collection.Shard' }

                    # if databases already exist (e.g. created by IaC but with no schema) then DROP ShardMapManager and Shard* databases to allow tool to re-create
                    if ($serverDatabases -contains $databaseName) {
                        $sqlQuery = ("DROP DATABASE [{0}];" -F $databaseName)
                        Invoke-SqlCmdQuery -SqlServer $SqlServer -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery
                    }
                    for ($shard = 0; $shard -lt [int]$shardNumber; $shard++) {
                        $shardDatabaseName = $shardNamePrefix + [string]$shard + $shardNameSuffix
                        if ($serverDatabases -contains $shardDatabaseName) {
                            $sqlQuery = ("DROP DATABASE [{0}];" -F $shardDatabaseName)
                            Invoke-SqlCmdQuery -SqlServer $SqlServer -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery
                        }
                    }

                    $shardTool = Join-Path -Path $ResourcesDirectory -ChildPath 'collectiondeployment\Sitecore.Xdb.Collection.Database.SqlShardingDeploymentTool.exe'
                    $shardToolArgs = (" /operation 'create' /connectionstring 'Server={0};User ID={1};Password={2}' /shardMapManagerDatabaseName '{3}' /shardnumber '{4}' /shardnameprefix '{5}'" -F $SqlServer, $SqlAdminUser, (Fix-SingleQuotes -String $SqlAdminPassword), $databaseName, $shardnumber, $shardNamePrefix)
                    if (-not [System.String]::IsNullOrEmpty($shardNameSuffix)) {
                        $shardToolArgs += (" /shardnamesuffix '{0}'" -F $shardNameSuffix)
                    }
                    if (-not [System.String]::IsNullOrEmpty($SqlElasticPoolName)) {
                        $shardToolArgs += (" /elasticpool '{0}'" -F $SqlElasticPoolName)
                    }
                    $shardToolArgs += (" /dacpac '{0}'" -F $dacpacFile)
                    Write-Information -Message ("shardtool" + ($shardToolArgs -replace (("Password=" + [regex]::Escape((Fix-SingleQuotes -String $SqlAdminPassword)) + "'"), "Password=********'")))
                    Invoke-Expression ("& ""$shardTool""" + $shardToolArgs)
                    if ($LASTEXITCODE -ne 0) {
                        throw ('Sitecore.Xdb.Collection.Database.SqlShardingDeploymentTool exited with code {0}.' -F $LASTEXITCODE)
                    }

                    # alter database for compatibility level (technically this should be before the .dacpac creation but qould require a change to SqlShardingDeploymentTool exe
                    if ((($serverDatabasesCreated -contains $databaseName) -or ($serverDatabases -contains $databaseName)) -and ($dacpacDatabasesCompatibilityLevel -notcontains $name)) {
                        $dacpacDatabasesCompatibilityLevel += $name
                        foreach ($sqlScript in ($Databases."$name".scripts | Where-Object { $_ -match '^sitecore_sql_database_compatibility_level\\compatibility_level_' })) {
                            $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                            (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                            Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments ("-b -V 11 -v DatabaseName='{0}'" -F $databaseName)
                            if ($LASTEXITCODE -ne 0) {
                                throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                            }
                            Remove-Item -LiteralPath $sqlFile -Force -ErrorAction SilentlyContinue

                        }
                        foreach ($sqlScript in ($Databases."$name".shard_scripts | Where-Object { $_ -match '^sitecore_sql_database_compatibility_level\\compatibility_level_' })) {
                            $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                            (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                            for ($shard = 0; $shard -lt [int]$shardNumber; $shard++) {
                                $shardDatabaseName = $shardNamePrefix + [string]$shard + $shardNameSuffix
                                Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $shardDatabaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments ("-b -V 11 -v DatabaseName='{0}'" -F $shardDatabaseName)
                                if ($LASTEXITCODE -ne 0) {
                                    throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                                }
                            }
                            Remove-Item -LiteralPath $sqlFile -Force -ErrorAction SilentlyContinue
                        }
                    }

                    # alter database for containment
                    if ($EnableContainedDatabases) {
                        foreach ($sqlScript in ($Databases."$name".scripts | Where-Object { $_ -match '^sitecore_sql_database_containment\\containment_' })) {
                            $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                            (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                            Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments ("-b -V 11 -v DatabaseName='{0}'" -F $databaseName)
                            if ($LASTEXITCODE -ne 0) {
                                throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                            }
                            Remove-Item -LiteralPath $sqlFile -Force -ErrorAction SilentlyContinue
                        }
                        foreach ($sqlScript in ($Databases."$name".shard_scripts | Where-Object { $_ -match '^sitecore_sql_database_containment\\containment_' })) {
                            $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                            (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                            for ($shard = 0; $shard -lt [int]$shardNumber; $shard++) {
                                $shardDatabaseName = $shardNamePrefix + [string]$shard + $shardNameSuffix
                                Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $shardDatabaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments ("-b -V 11 -v DatabaseName='{0}'" -F $shardDatabaseName)
                                if ($LASTEXITCODE -ne 0) {
                                    throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                                }
                            }
                            Remove-Item -LiteralPath $sqlFile -Force -ErrorAction SilentlyContinue
                        }
                    }

                    Write-Information -Message ("Deployed {0} database using {1} [Sitecore.Xdb.Collection.Database.SqlShardingDeploymentTool]" -F $databaseName, $dacpacName)
                }
            }
            else {
                # alter database for compatibility level
                if ((($serverDatabasesCreated -contains $databaseName) -or ($serverDatabases -contains $databaseName)) -and ($dacpacDatabasesCompatibilityLevel -notcontains $name)) {
                    $dacpacDatabasesCompatibilityLevel += $name
                    foreach ($sqlScript in ($Databases."$name".scripts | Where-Object { $_ -match '^sitecore_sql_database_compatibility_level\\compatibility_level_' })) {
                        $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                        (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                        Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments ("-b -V 11 -v DatabaseName='{0}'" -F $databaseName)
                        if ($LASTEXITCODE -ne 0) {
                            throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                        }
                        Remove-Item -LiteralPath $sqlFile -Force -ErrorAction SilentlyContinue
                    }
                }

                $sqlPackageToolArgs = (" /a:Publish /sf:'{0}' /tsn:'{1}' /tdn:'{2}' /p:AllowIncompatiblePlatform=True /p:ScriptDatabaseOptions={3}" -F $dacpacFile, $SqlServer, $databaseName, [string]([System.String]::IsNullOrEmpty($DatabasesToDeploy)))
                if ((-not [System.String]::IsNullOrEmpty($SqlAdminUser)) -and (-not [System.String]::IsNullOrEmpty($SqlAdminPassword))) {
                    $sqlPackageToolArgs += (" /tu:'{0}' /tp:'{1}'" -F $SqlAdminUser, (Fix-SingleQuotes -String $SqlAdminPassword))
                }
                Write-Information -Message ("sqlpackage" + ($sqlPackageToolArgs -replace (("/tp:'{0}'" -F [regex]::Escape((Fix-SingleQuotes -String $SqlAdminPassword))), "/tp:'********'")))
                Invoke-Expression ("& ""$sqlPackageTool""" + $sqlPackageToolArgs)
                if ($LASTEXITCODE -ne 0) {
                    throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $dacpacFile)
                }

                # if using a Sitecore.Security database then drop obsolete objects from both Sitecore.Core and Sitecore.Security
                if ($dacpacFile -eq (Join-Path -Path $ResourcesDirectory -ChildPath 'Sitecore.Core.dacpac')) {
                    if (($dacpacsDatabasesNameMap."$databaseName" -eq 'Sitecore.Core') -and ($Databases."Sitecore.Core".variables.databasename -ne $Databases."Sitecore.Security".variables.databasename)) {
                        foreach ($sqlScript in ($Databases."Sitecore.Core".scripts | Where-Object { $_ -match '^sitecore_security_database\\Sitecore\.Security_' })) {
                            $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                            (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                            Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments "-b -V 11"
                            if ($LASTEXITCODE -ne 0) {
                                throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                            }
                        }
                    }
                    elseif (($dacpacsDatabasesNameMap."$databaseName" -eq 'Sitecore.Security') -and ($Databases."Sitecore.Core".variables.databasename -ne $Databases."Sitecore.Security".variables.databasename)) {
                        foreach ($sqlScript in ($Databases."Sitecore.Security".scripts | Where-Object { $_ -match '^sitecore_security_database\\Sitecore\.Security_' })) {
                            $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                            (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                            Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments "-b -V 11"
                            if ($LASTEXITCODE -ne 0) {
                                throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlFile)
                            }
                        }
                    }
                }

                # alter database for containment
                if ($EnableContainedDatabases) {
                    foreach ($sqlScript in ($Databases."$name".scripts | Where-Object { $_ -match '^sitecore_sql_database_containment\\containment_' })) {
                        $sqlFile = (Join-Path -Path $ResourcesDirectory -ChildPath $sqlScript.Split(':')[0])
                        (Get-Content -LiteralPath $sqlFile -Raw) -replace (':SETVAR', '--:SETVAR') | Out-File -FilePath ($sqlFile = [IO.Path]::ChangeExtension($sqlFile, 'tmp.sql')) -Encoding UTF8
                        Invoke-SqlCmdFile -SqlServer $SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -File $sqlFile -Arguments ("-b -V 11 -v DatabaseName='{0}'" -F $databaseName)
                        if ($LASTEXITCODE -ne 0) {
                            throw ('sqlcmd exited with code {0} [{1}]' -F $LASTEXITCODE, $sqlFile)
                        }
                    }
                }

                Write-Information -Message ("Deployed {0} database using {1}" -F $databaseName, $dacpacName)

                if ([System.String]::IsNullOrEmpty($DatabasesToDeploy) -and (-not [string]::IsNullOrEmpty($DatabaseOwner))) {
                    $sqlQuery = Add-SqlAzureConditionWrapper -SqlQuery ($sqlQueryDatabaseOwner -F $DatabaseOwner)
                    Invoke-SqlCmdQuery -SqlServer:$SqlServer -SqlDatabase $databaseName -SqlUser $SqlAdminUser -SqlPassword $SqlAdminPassword -Query $sqlQuery -Arguments "-b -V 11"
                    if ($LASTEXITCODE -ne 0) {
                        throw ('sqlcmd exited with code {0} [{1}].' -F $LASTEXITCODE, $sqlQuery)
                    }
                }
            }
        }
    }

    if (-not $SkipStartingServer){
        Stop-Service -Name 'MSSQLSERVER'
    }
}
