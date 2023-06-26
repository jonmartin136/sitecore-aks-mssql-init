SET NOCOUNT ON;
GO

CREATE TYPE [NameListType] AS TABLE
(Name                 NVARCHAR(256) COLLATE CATALOG_DEFAULT);
GO

CREATE PROCEDURE [dbo].[sp_tmp_drop_multiple_objects]
@TypeOfObject         NVARCHAR(256),
@ObjectTable          NameListType     READONLY
AS
BEGIN
    DECLARE Names_Cursor CURSOR FOR
        SELECT Name FROM @ObjectTable;
    DECLARE @Name sysname;
    OPEN Names_Cursor;
    FETCH NEXT FROM Names_Cursor INTO @Name;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @sql NVARCHAR(4000);
        PRINT N'    DROP ' + @TypeOfObject + ' ' + QUOTENAME(@Name, '[');
        SET @sql = 'DROP ' + @TypeOfObject + ' ' + QUOTENAME(@Name, '[');
        EXEC (@sql);
        FETCH NEXT FROM Names_Cursor INTO @Name;
    END;
    CLOSE Names_Cursor;
    DEALLOCATE Names_Cursor;
END;
GO

CREATE PROCEDURE [dbo].[sp_tmp_drop_multiple_role_members]
@RolesTable        NameListType     READONLY
AS
BEGIN
    DECLARE Commands_Cursor CURSOR FOR
        SELECT 'ALTER ROLE ' +  QUOTENAME(rp.name)  + ' DROP MEMBER ' + QUOTENAME(mp.name)
        FROM sys.database_role_members drm
            JOIN sys.database_principals rp ON (drm.role_principal_id = rp.principal_id)
            JOIN sys.database_principals mp ON (drm.member_principal_id = mp.principal_id)
        WHERE rp.name IN (SELECT * FROM @RolesTable)
        ORDER BY rp.name;
    DECLARE @cmd VARCHAR(max);
    OPEN Commands_Cursor;
    FETCH NEXT FROM Commands_Cursor INTO @cmd;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT N'    ' + @cmd;
        EXEC (@cmd);
        FETCH NEXT FROM Commands_Cursor INTO @cmd;
    END;
    CLOSE Commands_Cursor;
    DEALLOCATE Commands_Cursor;
END;
GO

PRINT CHAR(13) + CHAR(10);
GO

DECLARE @TableList AS NameListType;
INSERT INTO @TableList VALUES (N'Blobs');
INSERT INTO @TableList VALUES (N'ClientData');
INSERT INTO @TableList VALUES (N'Descendants');
INSERT INTO @TableList VALUES (N'EventQueue');
INSERT INTO @TableList VALUES (N'History');
INSERT INTO @TableList VALUES (N'IDTable');
INSERT INTO @TableList VALUES (N'Items');
INSERT INTO @TableList VALUES (N'Links');
INSERT INTO @TableList VALUES (N'Notifications');
INSERT INTO @TableList VALUES (N'Properties');
INSERT INTO @TableList VALUES (N'PublishQueue');
INSERT INTO @TableList VALUES (N'SharedFields');
INSERT INTO @TableList VALUES (N'Tasks');
INSERT INTO @TableList VALUES (N'UnversionedFields');
INSERT INTO @TableList VALUES (N'VersionedFields');
INSERT INTO @TableList VALUES (N'WorkflowHistory');
INSERT INTO @TableList VALUES (N'AccessControl');
INSERT INTO @TableList VALUES (N'Archive');
INSERT INTO @TableList VALUES (N'ArchivedFields');
INSERT INTO @TableList VALUES (N'ArchivedItems');
INSERT INTO @TableList VALUES (N'ArchivedVersions');
EXEC [dbo].[sp_tmp_drop_multiple_objects] N'TABLE', @TableList;
GO

DECLARE @ViewList AS NameListType;
INSERT INTO @ViewList VALUES (N'Fields');

EXEC [dbo].[sp_tmp_drop_multiple_objects] N'VIEW', @ViewList;
GO

PRINT CHAR(13) + CHAR(10);
GO

DROP PROCEDURE [dbo].[sp_tmp_drop_multiple_objects];
DROP PROCEDURE [dbo].[sp_tmp_drop_multiple_role_members];
DROP TYPE [NameListType];
GO
