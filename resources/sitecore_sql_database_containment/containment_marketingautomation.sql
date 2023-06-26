:SETVAR DatabaseName PlaceHolderForDatabaseName

IF (DATABASEPROPERTYEX('$(DatabaseName)', 'containment') = 0)
BEGIN
    PRINT CHAR(13) + CHAR(10) + N'    ALTER DATABASE [$(DatabaseName)] SET CONTAINMENT = PARTIAL' + CHAR(13) + CHAR(10);
    EXEC ('ALTER DATABASE [$(DatabaseName)] SET CONTAINMENT = PARTIAL');
END;
GO
