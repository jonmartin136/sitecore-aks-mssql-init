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

DECLARE @RoleList AS NameListType;
INSERT INTO @RoleList VALUES (N'aspnet_Membership_BasicAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Membership_FullAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Membership_ReportingAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Personalization_BasicAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Personalization_FullAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Personalization_ReportingAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Profile_BasicAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Profile_FullAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Profile_ReportingAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Roles_BasicAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Roles_FullAccess');
INSERT INTO @RoleList VALUES (N'aspnet_Roles_ReportingAccess');
INSERT INTO @RoleList VALUES (N'aspnet_WebEvent_FullAccess');

EXEC [dbo].[sp_tmp_drop_multiple_role_members] @RoleList;
EXEC [dbo].[sp_tmp_drop_multiple_objects] N'SCHEMA', @RoleList;
EXEC [dbo].[sp_tmp_drop_multiple_objects] N'ROLE', @RoleList;
GO

DECLARE @TableList AS NameListType;
INSERT INTO @TableList VALUES (N'aspnet_WebEvent_Events');
INSERT INTO @TableList VALUES (N'aspnet_UsersInRoles');
INSERT INTO @TableList VALUES (N'aspnet_SchemaVersions');
INSERT INTO @TableList VALUES (N'aspnet_Roles');
INSERT INTO @TableList VALUES (N'aspnet_Profile');
INSERT INTO @TableList VALUES (N'aspnet_PersonalizationPerUser');
INSERT INTO @TableList VALUES (N'aspnet_PersonalizationAllUsers');
INSERT INTO @TableList VALUES (N'aspnet_Paths');
INSERT INTO @TableList VALUES (N'aspnet_Membership');
INSERT INTO @TableList VALUES (N'RolesInRoles');
INSERT INTO @TableList VALUES (N'UserLogins');
INSERT INTO @TableList VALUES (N'aspnet_Users');
INSERT INTO @TableList VALUES (N'aspnet_Applications');
INSERT INTO @TableList VALUES (N'PersistedGrants');
INSERT INTO @TableList VALUES (N'ExternalUserData');
INSERT INTO @TableList VALUES (N'DeviceCodes');

EXEC [dbo].[sp_tmp_drop_multiple_objects] N'TABLE', @TableList;
GO

DECLARE @ViewList AS NameListType;
INSERT INTO @ViewList VALUES (N'vw_aspnet_WebPartState_User');
INSERT INTO @ViewList VALUES (N'vw_aspnet_WebPartState_Shared');
INSERT INTO @ViewList VALUES (N'vw_aspnet_WebPartState_Paths');
INSERT INTO @ViewList VALUES (N'vw_aspnet_UsersInRoles');
INSERT INTO @ViewList VALUES (N'vw_aspnet_Users');
INSERT INTO @ViewList VALUES (N'vw_aspnet_Roles');
INSERT INTO @ViewList VALUES (N'vw_aspnet_Profiles');
INSERT INTO @ViewList VALUES (N'vw_aspnet_MembershipUsers');
INSERT INTO @ViewList VALUES (N'vw_aspnet_Applications');

EXEC [dbo].[sp_tmp_drop_multiple_objects] N'VIEW', @ViewList;
GO

DECLARE @ProcedureList AS NameListType;
INSERT INTO @ProcedureList VALUES (N'aspnet_AnyDataInTables');
INSERT INTO @ProcedureList VALUES (N'aspnet_Applications_CreateApplication');
INSERT INTO @ProcedureList VALUES (N'aspnet_CheckSchemaVersion');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_ChangePasswordQuestionAndAnswer');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_CreateUser');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_FindUsersByEmail');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_FindUsersByName');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_GetAllUsers');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_GetNumberOfUsersOnline');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_GetPassword');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_GetPasswordWithFormat');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_GetUserByEmail');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_GetUserByName');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_GetUserByUserId');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_ResetPassword');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_SetPassword');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_UnlockUser');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_UpdateUser');
INSERT INTO @ProcedureList VALUES (N'aspnet_Membership_UpdateUserInfo');
INSERT INTO @ProcedureList VALUES (N'aspnet_Paths_CreatePath');
INSERT INTO @ProcedureList VALUES (N'aspnet_Personalization_GetApplicationId');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAdministration_DeleteAllState');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAdministration_FindState');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAdministration_GetCountOfState');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAdministration_ResetSharedState');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAdministration_ResetUserState');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAllUsers_GetPageSettings');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAllUsers_ResetPageSettings');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationAllUsers_SetPageSettings');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationPerUser_GetPageSettings');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationPerUser_ResetPageSettings');
INSERT INTO @ProcedureList VALUES (N'aspnet_PersonalizationPerUser_SetPageSettings');
INSERT INTO @ProcedureList VALUES (N'aspnet_Profile_DeleteInactiveProfiles');
INSERT INTO @ProcedureList VALUES (N'aspnet_Profile_DeleteProfiles');
INSERT INTO @ProcedureList VALUES (N'aspnet_Profile_GetNumberOfInactiveProfiles');
INSERT INTO @ProcedureList VALUES (N'aspnet_Profile_GetProfiles');
INSERT INTO @ProcedureList VALUES (N'aspnet_Profile_GetProperties');
INSERT INTO @ProcedureList VALUES (N'aspnet_Profile_SetProperties');
INSERT INTO @ProcedureList VALUES (N'aspnet_RegisterSchemaVersion');
INSERT INTO @ProcedureList VALUES (N'aspnet_Roles_CreateRole');
INSERT INTO @ProcedureList VALUES (N'aspnet_Roles_DeleteRole');
INSERT INTO @ProcedureList VALUES (N'aspnet_Roles_GetAllRoles');
INSERT INTO @ProcedureList VALUES (N'aspnet_Roles_RoleExists');
INSERT INTO @ProcedureList VALUES (N'aspnet_Setup_RemoveAllRoleMembers');
INSERT INTO @ProcedureList VALUES (N'aspnet_Setup_RestorePermissions');
INSERT INTO @ProcedureList VALUES (N'aspnet_UnRegisterSchemaVersion');
INSERT INTO @ProcedureList VALUES (N'aspnet_Users_CreateUser');
INSERT INTO @ProcedureList VALUES (N'aspnet_Users_DeleteUser');
INSERT INTO @ProcedureList VALUES (N'aspnet_UsersInRoles_AddUsersToRoles');
INSERT INTO @ProcedureList VALUES (N'aspnet_UsersInRoles_FindUsersInRole');
INSERT INTO @ProcedureList VALUES (N'aspnet_UsersInRoles_GetRolesForUser');
INSERT INTO @ProcedureList VALUES (N'aspnet_UsersInRoles_GetUsersInRoles');
INSERT INTO @ProcedureList VALUES (N'aspnet_UsersInRoles_IsUserInRole');
INSERT INTO @ProcedureList VALUES (N'aspnet_UsersInRoles_RemoveUsersFromRoles');
INSERT INTO @ProcedureList VALUES (N'aspnet_WebEvent_LogEvent');

EXEC [dbo].[sp_tmp_drop_multiple_objects] N'PROCEDURE', @ProcedureList;
GO

PRINT CHAR(13) + CHAR(10);
GO

DROP PROCEDURE [dbo].[sp_tmp_drop_multiple_objects];
DROP PROCEDURE [dbo].[sp_tmp_drop_multiple_role_members];
DROP TYPE [NameListType];
GO
