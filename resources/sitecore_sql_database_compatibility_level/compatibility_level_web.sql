:SETVAR DatabaseName PlaceHolderForDatabaseName

IF ((SELECT [compatibility_level] FROM [sys].[databases] WHERE [name] = '$(DatabaseName)') <> 140)
BEGIN
    PRINT CHAR(13) + CHAR(10) + N'    ALTER DATABASE [$(DatabaseName)] SET COMPATIBILITY_LEVEL = 140' + CHAR(13) + CHAR(10);
    ALTER DATABASE [$(DatabaseName)] SET COMPATIBILITY_LEVEL = 140;
END
ELSE
BEGIN
    PRINT N'$(DatabaseName) ALREADY HAS [compatibility_level] = 140';
END;
GO
