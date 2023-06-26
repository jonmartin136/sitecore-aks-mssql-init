# Sitecore for AKS 'mssql-init' wrapper

The 'Dockerfile' file describes the changes made to the ENTRYPOINT (parameters of StartInit.ps1). In this example we have added some extra users
to each database and the XP-1 configuration is using separate Sitecore.Core + Sitecore.Security databases, Geo-replication set-up and two publishing targets.

Any client based changes can be made by adding a directory to the 'resources' folder. In this example we have prefixed any client specific folders as 'client_*'.

All the CreateUser*.sql scripts have been reworked to allow for repeated execution (e.g. add to a pipeline for all releases) and on secondary runs will update
the password and reset the user's permissions.

The PowerShell scripts have been written to run using PowerShell Desktop Edition (v5) - this is based upon Sitecore's current implementation. We had problems with the ENTRYPOINT parameters when testing with PowerShell Core (v7). The 'InstallPrerequisites2.ps1.txt' file has been included for future upgrade to using PowerShell Core but is currently redundant.

The main advantage of PowerShell Core is to use the `ConvertFrom-Json -AsHashtable` parameter. A workaround for Desktop Edition has been implemented by using https://4sysops.com/archives/convert-json-to-a-powershell-hash-table/

The concept is for each 'resources' sub-folder to define its requirements using 'databases.json'. The script will then merge these together and take action on the final configuration.
The syntax for this file is very similar to Sitecore's standard version.

For example:
```
    "Sitecore.Core": {
        "scripts": [
            "CreateUserServerLogin.Core.sql:UserName=username UserPassword=password DatabaseName=databasename",
            "CreateUser.Core.sql:UserName=username UserPassword=password DatabaseName=databasename"
        ],
        "variables": {
            "databasename": "Sitecore.Core",
            "username": "",
            "password": ""
        },
        "dacpacs": [
            "Sitecore.Core.dacpac"
        ]
    }
```

The 'Sitecore.Core' object (in the example above) matches the 'name' attribute as per '-DatabaseUsers' parameter and should be the standard Sitecore database names, e.g. Sitecore.Core, Sitecore.Web etc.

The 'scripts' object is an array with each element containing the script name; if required it is followed by a colon symbol and then a space separated list of name/value pairs that meet the script's required parameters.

The 'value' property of these parameters references the 'name' property within the 'variables' object (e.g. databasename, username, and password) and their values would normally be passed via the '-DatabaseUsers' parameter as defined in the ENTRYPOINT.

A special prefix to the script name can be applied as
- '[+]' case that adds the script only if the same named script already exists (different parameters/values to be passed), i.e. re-use the same SQL script with different name/value parameters
- '[-]' case that removes all existing scripts of the same name (regardless of modules folder location) but only if parameters are identical (required for 'sitecore_security_database')

The syntax for the Shard* databases have been updated slightly but can be considered a black-box with the exception of the 'variables' object where
- 'shardmax' is the maximum number of shard databases wanted (default is 2)
- 'sharddatabasenameprefix' is the database name prefix - clients might need to change this as per any Azure naming convention
- 'sharddatabasenamesuffix' is the database name suffix

and the 'shard_scripts' object which is used for Shard specific scripts (compared to the ShardMapManager  'scripts' object).

The 'dacpacs' object is an array with each element listing the .dacpac schema file to run when creating the database schema. When creating a custom database, e.g. Web2, then this would refer back to the standard 'Sitecore.Web.dacpac' file.
 
An important design decision to understand is that the script only runs the schema creation (i.e. the .dacpac file) based upon the assumption that no users exist on the database. This is safe when databases changes are only made via this process because from an empty database the order of actions are:
- create schema
- add database users plus any optional client based scripts

### Drop old users (client based example)
Add 'resources/client_drop_old_users' and include
- databases.json
```
    {
        "Sitecore.Core": {
            "scripts": [
                "client_drop_old_users\\CreateUserToDrop.sql"
            ],
            "variables": {
            }
        },
        "Sitecore.Master": {
            "scripts": [
                "client_drop_old_users\\CreateUserToDrop.sql"
            ],
            "variables": {
            }
        }
    }
```
  NOTE: By default the 'StartInit.ps1' script will automatically run any script called 'CreateUser*' or 'CreateShard*' so using this unusal file naming saves a little extra effort - would need to specify them by using the '-DatabasesScripts' parameter otherwise
- sql scripts, e.g. CreateUserToDrop.sql
```
    IF (EXISTS (SELECT 1 FROM [sys].[database_principals] WHERE [name] = 'sitecore-old-user'))
    BEGIN
        PRINT N'Removing user [sitecore-old-user]...';
        DROP USER [sitecore-old-user];
    END;
    GO
```

### Add Stored Procedures to Sitecore.ExperienceForms database (client based example)
Add 'resources/client_experienceforms' and include
- databases.json
```
     {
         "Sitecore.ExperienceForms": {
             "scripts": [
                 "client_experienceforms\\FormData_ActionAStoredProcedure.sql",
                 "client_experienceforms\\FormData_ActionBStoredProcedure.sql"
             ],
             "variables": {
                 "databasename": "Sitecore.ExperienceForms"
             }
         }
     }
```
- sql scripts, e.g. FormData_ActionAStoredProcedure.sql & FormData_ActionBStoredProcedure.sql

  NOTE: Additionally, we would need to update '-DatabasesScripts' parameter (regex) so $env:DATABASES_SCRIPTS = 'FormData_Action' would suffice.
