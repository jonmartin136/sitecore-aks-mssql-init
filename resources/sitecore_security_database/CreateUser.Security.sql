:SETVAR UserName PlaceHolderForUserName
:SETVAR UserPassword PlaceHolderForUserPassword
:SETVAR DatabaseName PlaceHolderForDatabaseName

DECLARE @containmentLevel tinyint = CONVERT(tinyint, (SELECT DATABASEPROPERTYEX('$(DatabaseName)', 'containment')));
IF (NOT EXISTS (SELECT 1 FROM [sys].[database_principals] WHERE [name] = '$(UserName)'))
BEGIN
    PRINT N'Creating user [$(UserName)]...';
    IF (@containmentLevel = 0)
        CREATE USER [$(UserName)] FOR LOGIN [$(UserName)];
    ELSE
        CREATE USER [$(UserName)] WITH PASSWORD = '$(UserPassword)';
END
ELSE IF (@containmentLevel = 0)
BEGIN
    PRINT N'Remapping user for login [$(UserName)]...';
    ALTER USER [$(UserName)] WITH LOGIN = [$(UserName)]
END
ELSE
BEGIN
    PRINT N'Updating password for user [$(UserName)]...';
    ALTER USER [$(UserName)] WITH PASSWORD = '$(UserPassword)';
END;
GO

PRINT N'Resetting roles for user [$(UserName)]...';
EXEC [dbo].[sp_addrolemember] 'db_datareader', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'db_datawriter', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Membership_BasicAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Membership_FullAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Membership_ReportingAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Profile_BasicAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Profile_FullAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Profile_ReportingAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Roles_BasicAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Roles_FullAccess', [$(UserName)];
EXEC [dbo].[sp_addrolemember] 'aspnet_Roles_ReportingAccess', [$(UserName)];
GO

GRANT CONNECT TO [$(UserName)];
GRANT EXECUTE TO [$(UserName)];
GO
