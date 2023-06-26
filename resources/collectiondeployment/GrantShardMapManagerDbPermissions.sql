:SETVAR UserName PlaceHolderForUserName

GRANT SELECT ON SCHEMA :: __ShardManagement TO [$(UserName)];
GRANT EXECUTE ON SCHEMA :: __ShardManagement TO [$(UserName)];
GO
