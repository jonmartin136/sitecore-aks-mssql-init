:SETVAR UserName PlaceHolderForUser
:SETVAR UserSID PlaceHolderForUserSID
:SETVAR UserType PlaceHolderForUserType

IF (NOT EXISTS (SELECT 1 FROM [sys].[database_principals] WHERE [name] = '$(UserName)'))
BEGIN
    PRINT N'Creating external provider user [$(UserName)]...';
    CREATE USER [$(UserName)] WITH SID = $(UserSID), TYPE = $(UserType);
END;
GO

PRINT N'Resetting roles for user [$(UserName)]...';
EXECUTE [dbo].[sp_addrolemember] 'db_datareader', [$(UserName)];
GO

GRANT CONNECT TO [$(UserName)];
GRANT EXECUTE TO [$(UserName)];
GO
