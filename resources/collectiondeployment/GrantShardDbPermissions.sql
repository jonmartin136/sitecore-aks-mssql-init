:SETVAR UserName PlaceHolderForUserName

EXEC [xdb_collection].[GrantLeastPrivilege] @UserName = '$(UserName)';
GO
