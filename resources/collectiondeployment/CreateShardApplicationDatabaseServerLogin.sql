:SETVAR UserName PlaceHolderForUserName
:SETVAR UserPassword PlaceHolderForUserPassword
:SETVAR DatabaseName PlaceHolderForDatabaseName

DECLARE @containmentLevel tinyint = CONVERT(tinyint, (SELECT DATABASEPROPERTYEX('$(DatabaseName)', 'containment')));
IF (@containmentLevel = 0)
BEGIN
    IF (SUSER_ID('$(UserName)') IS NULL)
    BEGIN
        PRINT N'Creating login [$(UserName)]...';
        CREATE LOGIN [$(UserName)] WITH PASSWORD = '$(UserPassword)';
    END
    ELSE
    BEGIN
        PRINT N'Updating password for login [$(UserName)]...';
        ALTER LOGIN [$(UserName)] WITH PASSWORD = '$(UserPassword)';
    END
END;
GO
