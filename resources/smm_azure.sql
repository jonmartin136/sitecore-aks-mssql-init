:SETVAR ServerName PlaceHolderForServerName
:SETVAR Shard0DbName PlaceHolderForShard0DbName
:SETVAR Shard1DbName PlaceHolderForShard1DbName
GO

CREATE SCHEMA [__ShardManagement] AUTHORIZATION [dbo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [__ShardManagement].[fnGetStoreVersionMajorGlobal]()
returns int
as
begin
	return (select StoreVersionMajor from __ShardManagement.ShardMapManagerGlobal)
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[fnGetStoreVersionMajorGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[OperationsLogGlobal](
	[OperationId] [uniqueidentifier] NOT NULL,
	[OperationCode] [int] NOT NULL,
	[Data] [xml] NOT NULL,
	[UndoStartState] [int] NOT NULL,
	[ShardVersionRemoves] [uniqueidentifier] NULL,
	[ShardVersionAdds] [uniqueidentifier] NULL,
 CONSTRAINT [pkOperationsLogGlobal_OperationId] PRIMARY KEY CLUSTERED 
(
	[OperationId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[OperationsLogGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal](
	[Name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SchemaInfo] [xml] NOT NULL,
 CONSTRAINT [pkShardedDatabaseSchemaInfosGlobal_Name] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMapManagerGlobal](
	[StoreVersionMajor] [int] NOT NULL,
	[StoreVersionMinor] [int] NOT NULL,
 CONSTRAINT [pkShardMapManagerGlobal_StoreVersionMajor] PRIMARY KEY CLUSTERED 
(
	[StoreVersionMajor] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardMapManagerGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMappingsGlobal](
	[MappingId] [uniqueidentifier] NOT NULL,
	[Readable] [bit] NOT NULL,
	[ShardId] [uniqueidentifier] NOT NULL,
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[OperationId] [uniqueidentifier] NULL,
	[MinValue] [varbinary](128) NOT NULL,
	[MaxValue] [varbinary](128) NULL,
	[Status] [int] NOT NULL,
	[LockOwnerId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pkShardMappingsGlobal_ShardMapId_MinValue_Readable] PRIMARY KEY CLUSTERED 
(
	[ShardMapId] ASC,
	[MinValue] ASC,
	[Readable] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardMappingsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMapsGlobal](
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ShardMapType] [int] NOT NULL,
	[KeyType] [int] NOT NULL,
 CONSTRAINT [pkShardMapsGlobal_ShardMapId] PRIMARY KEY CLUSTERED 
(
	[ShardMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardMapsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardsGlobal](
	[ShardId] [uniqueidentifier] NOT NULL,
	[Readable] [bit] NOT NULL,
	[Version] [uniqueidentifier] NOT NULL,
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[OperationId] [uniqueidentifier] NULL,
	[Protocol] [int] NOT NULL,
	[ServerName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Port] [int] NOT NULL,
	[DatabaseName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [pkShardsGlobal_ShardId] PRIMARY KEY CLUSTERED 
(
	[ShardId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardsGlobal] TO  SCHEMA OWNER 
GO
INSERT [__ShardManagement].[ShardMapManagerGlobal] ([StoreVersionMajor], [StoreVersionMinor]) VALUES (1, 2)
INSERT [__ShardManagement].[ShardMappingsGlobal] ([MappingId], [Readable], [ShardId], [ShardMapId], [OperationId], [MinValue], [MaxValue], [Status], [LockOwnerId]) VALUES (N'a2071a40-792b-496a-8adb-2237a033734c', 1, N'f7362703-e517-4a86-9577-14c9c365a3f8', N'd05a1cfc-644c-4ecb-9438-462172f69335', NULL, 0x, 0x80, 1, N'00000000-0000-0000-0000-000000000000')
INSERT [__ShardManagement].[ShardMappingsGlobal] ([MappingId], [Readable], [ShardId], [ShardMapId], [OperationId], [MinValue], [MaxValue], [Status], [LockOwnerId]) VALUES (N'fe6b9147-485a-4e78-8f60-8ddadb80cf71', 1, N'39085848-6a4a-4ace-9519-e03669edf410', N'd05a1cfc-644c-4ecb-9438-462172f69335', NULL, 0x80, NULL, 1, N'00000000-0000-0000-0000-000000000000')
INSERT [__ShardManagement].[ShardMappingsGlobal] ([MappingId], [Readable], [ShardId], [ShardMapId], [OperationId], [MinValue], [MaxValue], [Status], [LockOwnerId]) VALUES (N'c272a784-b721-411d-ba7b-323b3ff19fb4', 1, N'f4ab4dd7-514c-49bc-b28a-be611531d3f5', N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', NULL, 0x, 0x80, 1, N'00000000-0000-0000-0000-000000000000')
INSERT [__ShardManagement].[ShardMappingsGlobal] ([MappingId], [Readable], [ShardId], [ShardMapId], [OperationId], [MinValue], [MaxValue], [Status], [LockOwnerId]) VALUES (N'9e53a695-4a72-47b4-99a6-21838550a1ad', 1, N'38f4e152-678b-4be2-864a-a60ae8e33dc4', N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', NULL, 0x80, NULL, 1, N'00000000-0000-0000-0000-000000000000')
INSERT [__ShardManagement].[ShardMappingsGlobal] ([MappingId], [Readable], [ShardId], [ShardMapId], [OperationId], [MinValue], [MaxValue], [Status], [LockOwnerId]) VALUES (N'4cb02d85-98bf-4810-b1eb-125fc90b3f56', 1, N'e969a18c-f922-46d3-a51e-fadc58373fca', N'60c1f275-b533-41ec-8fd4-b791518bfa2f', NULL, 0x, 0x80, 1, N'00000000-0000-0000-0000-000000000000')
INSERT [__ShardManagement].[ShardMappingsGlobal] ([MappingId], [Readable], [ShardId], [ShardMapId], [OperationId], [MinValue], [MaxValue], [Status], [LockOwnerId]) VALUES (N'50df06ae-6c7a-45fa-892b-af3bf41e2b02', 1, N'f15b6d60-3950-4147-b4c5-3280f16ac5e0', N'60c1f275-b533-41ec-8fd4-b791518bfa2f', NULL, 0x80, NULL, 1, N'00000000-0000-0000-0000-000000000000')
INSERT [__ShardManagement].[ShardMapsGlobal] ([ShardMapId], [Name], [ShardMapType], [KeyType]) VALUES (N'd05a1cfc-644c-4ecb-9438-462172f69335', N'ContactIdentifiersIndexShardMap', 2, 4)
INSERT [__ShardManagement].[ShardMapsGlobal] ([ShardMapId], [Name], [ShardMapType], [KeyType]) VALUES (N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', N'ContactIdShardMap', 2, 4)
INSERT [__ShardManagement].[ShardMapsGlobal] ([ShardMapId], [Name], [ShardMapType], [KeyType]) VALUES (N'60c1f275-b533-41ec-8fd4-b791518bfa2f', N'DeviceProfileIdShardMap', 2, 4)
INSERT [__ShardManagement].[ShardsGlobal] ([ShardId], [Readable], [Version], [ShardMapId], [OperationId], [Protocol], [ServerName], [Port], [DatabaseName], [Status]) VALUES (N'f7362703-e517-4a86-9577-14c9c365a3f8', 1, N'99e168e2-0bc3-49ee-9a54-6e85af155751', N'd05a1cfc-644c-4ecb-9438-462172f69335', NULL, 0, N'$(ServerName)', 0, N'$(Shard0DbName)', 1)
INSERT [__ShardManagement].[ShardsGlobal] ([ShardId], [Readable], [Version], [ShardMapId], [OperationId], [Protocol], [ServerName], [Port], [DatabaseName], [Status]) VALUES (N'f15b6d60-3950-4147-b4c5-3280f16ac5e0', 1, N'492eb0e4-2cb9-45f6-9c21-a1431e449e59', N'60c1f275-b533-41ec-8fd4-b791518bfa2f', NULL, 0, N'$(ServerName)', 0, N'$(Shard1DbName)', 1)
INSERT [__ShardManagement].[ShardsGlobal] ([ShardId], [Readable], [Version], [ShardMapId], [OperationId], [Protocol], [ServerName], [Port], [DatabaseName], [Status]) VALUES (N'38f4e152-678b-4be2-864a-a60ae8e33dc4', 1, N'552be935-6219-4ce6-9cdf-8b86b817d379', N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', NULL, 0, N'$(ServerName)', 0, N'$(Shard1DbName)', 1)
INSERT [__ShardManagement].[ShardsGlobal] ([ShardId], [Readable], [Version], [ShardMapId], [OperationId], [Protocol], [ServerName], [Port], [DatabaseName], [Status]) VALUES (N'f4ab4dd7-514c-49bc-b28a-be611531d3f5', 1, N'3e5af7e1-05ad-437f-86e0-80226bebee93', N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', NULL, 0, N'$(ServerName)', 0, N'$(Shard0DbName)', 1)
INSERT [__ShardManagement].[ShardsGlobal] ([ShardId], [Readable], [Version], [ShardMapId], [OperationId], [Protocol], [ServerName], [Port], [DatabaseName], [Status]) VALUES (N'39085848-6a4a-4ace-9519-e03669edf410', 1, N'a52a26f0-dfd4-44ef-937c-d103862b7f41', N'd05a1cfc-644c-4ecb-9438-462172f69335', NULL, 0, N'$(ServerName)', 0, N'$(Shard1DbName)', 1)
INSERT [__ShardManagement].[ShardsGlobal] ([ShardId], [Readable], [Version], [ShardMapId], [OperationId], [Protocol], [ServerName], [Port], [DatabaseName], [Status]) VALUES (N'e969a18c-f922-46d3-a51e-fadc58373fca', 1, N'587b31e9-33d0-4afe-9083-6b6ed75a0793', N'60c1f275-b533-41ec-8fd4-b791518bfa2f', NULL, 0, N'$(ServerName)', 0, N'$(Shard0DbName)', 1)
INSERT [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] ([Name], [SchemaInfo]) VALUES (N'ContactIdentifiersIndexShardMap', N'<Schema xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><ReferenceTableSet i:type="ArrayOfReferenceTableInfo" /><ShardedTableSet i:type="ArrayOfShardedTableInfo"><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>ContactIdentifiersIndex</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo></ShardedTableSet></Schema>')
INSERT [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] ([Name], [SchemaInfo]) VALUES (N'ContactIdShardMap', N'<Schema xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><ReferenceTableSet i:type="ArrayOfReferenceTableInfo" /><ShardedTableSet i:type="ArrayOfShardedTableInfo"><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>Contacts</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>ContactFacets</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>ContactIdentifiers</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>Interactions</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>InteractionFacets</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo></ShardedTableSet></Schema>')
INSERT [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] ([Name], [SchemaInfo]) VALUES (N'DeviceProfileIdShardMap', N'<Schema xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><ReferenceTableSet i:type="ArrayOfReferenceTableInfo" /><ShardedTableSet i:type="ArrayOfShardedTableInfo"><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>DeviceProfileFacets</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>DeviceProfiles</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo></ShardedTableSet></Schema>')
GO

ALTER TABLE [__ShardManagement].[ShardMappingsGlobal] ADD  CONSTRAINT [ucShardMappingsGlobal_MappingId] UNIQUE NONCLUSTERED 
(
	[MappingId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF)
GO
SET ANSI_PADDING ON

GO

ALTER TABLE [__ShardManagement].[ShardMapsGlobal] ADD  CONSTRAINT [ucShardMapsGlobal_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF)
GO
SET ANSI_PADDING ON

GO

ALTER TABLE [__ShardManagement].[ShardsGlobal] ADD  CONSTRAINT [ucShardsGlobal_Location] UNIQUE NONCLUSTERED 
(
	[ShardMapId] ASC,
	[Protocol] ASC,
	[ServerName] ASC,
	[DatabaseName] ASC,
	[Port] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF)
GO
ALTER TABLE [__ShardManagement].[OperationsLogGlobal] ADD  DEFAULT ((100)) FOR [UndoStartState]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsGlobal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LockOwnerId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsGlobal]  WITH CHECK ADD  CONSTRAINT [fkShardMappingsGlobal_ShardId] FOREIGN KEY([ShardId])
REFERENCES [__ShardManagement].[ShardsGlobal] ([ShardId])
GO
ALTER TABLE [__ShardManagement].[ShardMappingsGlobal] CHECK CONSTRAINT [fkShardMappingsGlobal_ShardId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsGlobal]  WITH CHECK ADD  CONSTRAINT [fkShardMappingsGlobal_ShardMapId] FOREIGN KEY([ShardMapId])
REFERENCES [__ShardManagement].[ShardMapsGlobal] ([ShardMapId])
GO
ALTER TABLE [__ShardManagement].[ShardMappingsGlobal] CHECK CONSTRAINT [fkShardMappingsGlobal_ShardMapId]
GO
ALTER TABLE [__ShardManagement].[ShardsGlobal]  WITH CHECK ADD  CONSTRAINT [fkShardsGlobal_ShardMapId] FOREIGN KEY([ShardMapId])
REFERENCES [__ShardManagement].[ShardMapsGlobal] ([ShardMapId])
GO
ALTER TABLE [__ShardManagement].[ShardsGlobal] CHECK CONSTRAINT [fkShardsGlobal_ShardMapId]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spAddShardingSchemaInfoGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@name nvarchar(128),
			@schemaInfo xml

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@name = x.value('(SchemaInfo/Name)[1]', 'nvarchar(128)'),
		@schemaInfo = x.query('SchemaInfo/Info/*')
	from 
		@input.nodes('/AddShardingSchemaInfoGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @name is null or @schemaInfo is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if exists (
		select 
			Name 
		from 
			__ShardManagement.ShardedDatabaseSchemaInfosGlobal 
		where 
			Name = @name)
		goto Error_SchemaInfoAlreadyExists;
	
	insert into
		__ShardManagement.ShardedDatabaseSchemaInfosGlobal
		(Name, SchemaInfo)
	values
		(@name, @schemaInfo)

	set @result = 1
	goto Exit_Procedure;

Error_SchemaInfoAlreadyExists:
	set @result = 402
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spAddShardingSchemaInfoGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spAddShardMapGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@name nvarchar(50),
			@mapType int,
			@keyType int

	select 
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@name = x.value('(ShardMap/Name)[1]', 'nvarchar(50)'),
		@mapType = x.value('(ShardMap/Kind)[1]', 'int'),
		@keyType = x.value('(ShardMap/KeyKind)[1]', 'int')
	from 
		@input.nodes('/AddShardMapGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null or @name is null or @mapType is null or @keyType is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;
		
	begin try
		insert into 
			__ShardManagement.ShardMapsGlobal 
			(ShardMapId, Name, ShardMapType, KeyType)
		values 
			(@shardMapId, @name, @mapType, @keyType) 
	end try
	begin catch
		if (error_number() = 2627)
			goto Error_ShardMapAlreadyExists;
		else
		begin
			declare @errorMessage nvarchar(max) = error_message(),
					@errorNumber int = error_number(),
					@errorSeverity int = error_severity(),
					@errorState int = error_state(),
					@errorLine int = error_line(),
					@errorProcedure nvarchar(128) = isnull(error_procedure(), '-');

			select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage;
			
			raiserror (@errorMessage, @errorSeverity, 1, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			
			rollback transaction; -- To avoid extra error message in response.
			goto Error_UnexpectedError;
		end
	end catch
		
	set @result = 1
	goto Exit_Procedure;
		
Error_ShardMapAlreadyExists:
	set @result = 101
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_UnexpectedError:
	set @result = 53
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spAddShardMapGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spAttachShardGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int, 
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@name nvarchar(50),
			@mapType int,
			@keyType int,
			@shardId uniqueidentifier,
			@shardVersion uniqueidentifier,
			@protocol int,
			@serverName nvarchar(128),
			@port int,
			@databaseName nvarchar(128),
			@shardStatus int

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@name = x.value('(ShardMap/Name)[1]', 'nvarchar(50)'),
		@mapType = x.value('(ShardMap/Kind)[1]', 'int'),
		@keyType = x.value('(ShardMap/KeyKind)[1]', 'int'),

		@shardId = x.value('(Shard/Id)[1]', 'uniqueidentifier'),
		@shardVersion = x.value('(Shard/Version)[1]', 'uniqueidentifier'),
		@protocol = x.value('(Shard/Location/Protocol)[1]', 'int'),
		@serverName = x.value('(Shard/Location/ServerName)[1]', 'nvarchar(128)'),
		@port = x.value('(Shard/Location/Port)[1]', 'int'),
		@databaseName = x.value('(Shard/Location/DatabaseName)[1]', 'nvarchar(128)'),
		@shardStatus = x.value('(Shard/Status)[1]', 'int')
	from
		@input.nodes('/AttachShardGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null or @name is null or @mapType is null or @keyType is null or
		@shardId is null or @shardVersion is null or @protocol is null or @serverName is null or 
		@port is null or @databaseName is null or @shardStatus is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if exists (
	select 
		ShardMapId
	from
		__ShardManagement.ShardMapsGlobal 
	where
		(ShardMapId = @shardMapId and Name <> @name) or (ShardMapId <> @shardMapId and Name = @name))
		goto Error_ShardMapAlreadyExists;

	begin try
		insert into 
			__ShardManagement.ShardMapsGlobal 
			(ShardMapId, Name, ShardMapType, KeyType)
		values 
			(@shardMapId, @name, @mapType, @keyType) 
	end try
	begin catch
		if (error_number() <> 2627)
		begin
			declare @errorMessage nvarchar(max) = error_message(),
					@errorNumber int = error_number(),
					@errorSeverity int = error_severity(),
					@errorState int = error_state(),
					@errorLine int = error_line(),
					@errorProcedure nvarchar(128) = isnull(error_procedure(), '-');

			select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage;
			
			raiserror (@errorMessage, @errorSeverity, 1, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			
			rollback transaction; -- To avoid extra error message in response.
			goto Error_UnexpectedError;
		end
	end catch

	begin try
		insert into 
			__ShardManagement.ShardsGlobal (
			ShardId, 
			Readable, 
			Version, 
			ShardMapId, 
			OperationId, 
			Protocol, 
			ServerName, 
			Port, 
			DatabaseName, 
			Status)
		values (
			@shardId, 
			1, 
			@shardVersion, 
			@shardMapId, 
			null, 
			@protocol, 
			@serverName, 
			@port, 
			@databaseName, 
			@shardStatus) 
	end try
	begin catch
		if (error_number() = 2627)
			goto Error_ShardLocationAlreadyExists;
		else
		begin
			set @errorMessage = error_message()
			set	@errorNumber = error_number()
			set @errorSeverity = error_severity()
			set @errorState = error_state()
			set @errorLine = error_line()
			set @errorProcedure = isnull(error_procedure(), '-')

			select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage;
			
			raiserror (@errorMessage, @errorSeverity, 2, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			
			rollback transaction; -- To avoid extra error message in response.
			goto Error_UnexpectedError;
		end
	end catch
	
	set @result = 1
	goto Exit_Procedure;

Error_ShardMapAlreadyExists:
	set @result = 101
	goto Exit_Procedure;

Error_ShardLocationAlreadyExists:
	set @result = 205
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_UnexpectedError:
	set @result = 53
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spAttachShardGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spBulkOperationShardMappingsGlobalBegin]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@operationCode int,
			@stepsCount int,
			@shardMapId uniqueidentifier

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@operationCode = x.value('(@OperationCode)[1]', 'int'),
		@stepsCount = x.value('(@StepsCount)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier')
	from
		@input.nodes('/BulkOperationShardMappingsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @operationId is null or @operationCode is null or 
		@stepsCount is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	declare @shardMapType int

	select 
		@shardMapType = ShardMapType
	from
		__ShardManagement.ShardMapsGlobal with (updlock)
	where
		ShardMapId = @shardMapId

	if (@shardMapType is null)
		goto Error_ShardMapNotFound;

	declare @shardIdForRemoves uniqueidentifier,
			@originalShardVersionForRemoves uniqueidentifier,
			@shardIdForAdds uniqueidentifier,
			@originalShardVersionForAdds uniqueidentifier,
			@currentShardOperationId uniqueidentifier

	select 
		@shardIdForRemoves = x.value('(Removes/Shard/Id)[1]', 'uniqueidentifier'),
		@shardIdForAdds = x.value('(Adds/Shard/Id)[1]', 'uniqueidentifier')
	from 
		@input.nodes('/BulkOperationShardMappingsGlobal') as t(x)

	if (@shardIdForRemoves is null or @shardIdForAdds is null)
		goto Error_MissingParameters;

	select
		@originalShardVersionForRemoves = Version,
		@currentShardOperationId = OperationId
	from
		__ShardManagement.ShardsGlobal with (updlock)
	where
		ShardMapId = @shardMapId and ShardId = @shardIdForRemoves and Readable = 1
	
	if (@currentShardOperationId = @operationId)
		goto Success_Exit;

	if (@currentShardOperationId is not null)
		goto Error_ShardPendingOperation;

	if (@originalShardVersionForRemoves is null)
		goto Error_ShardDoesNotExist;

	update __ShardManagement.ShardsGlobal
	set
		OperationId = @operationId
	where
		ShardMapId = @shardMapId and ShardId = @shardIdForRemoves

	set @currentShardOperationId = null;

	if (@shardIdForRemoves <> @shardIdForAdds)
	begin
		select
			@originalShardVersionForAdds = Version,
			@currentShardOperationId = OperationId
		from
			__ShardManagement.ShardsGlobal with (updlock)
		where
			ShardMapId = @shardMapId and ShardId = @shardIdForAdds and Readable = 1
	
		if (@currentShardOperationId = @operationId)
			goto Success_Exit;

		if (@currentShardOperationId is not null)
			goto Error_ShardPendingOperation;

		if (@originalShardVersionForAdds is null)
			goto Error_ShardDoesNotExist;

		update __ShardManagement.ShardsGlobal
		set
			OperationId = @operationId
		where
			ShardMapId = @shardMapId and ShardId = @shardIdForAdds
	end
	else
	begin
		set @originalShardVersionForAdds = @originalShardVersionForRemoves
	end
	
	begin try
		insert into __ShardManagement.OperationsLogGlobal(
			OperationId,
			OperationCode,
			Data,
			ShardVersionRemoves,
			ShardVersionAdds)
		values (
			@operationId,
			@operationCode,
			@input,
			@originalShardVersionForRemoves,
			@originalShardVersionForAdds)
	end try
	begin catch
		if (error_number() <> 2627)
		begin
			declare @errorMessage nvarchar(max) = error_message(),
					@errorNumber int = error_number(),
					@errorSeverity int = error_severity(),
					@errorState int = error_state(),
					@errorLine int = error_line(),
					@errorProcedure nvarchar(128) = isnull(error_procedure(), '-');

			select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage;
			
			raiserror (@errorMessage, @errorSeverity, 1, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			
			rollback transaction; -- To avoid extra error message in response.
			goto Error_UnexpectedError;
		end
	end catch

	declare	@currentStep xml,
			@stepIndex int = 1,
			@stepType int,
			@stepMappingId uniqueidentifier,
			@stepLockOwnerId uniqueidentifier

	declare	@currentLockOwnerId uniqueidentifier,
			@currentStatus int

	declare @stepStatus int,
			@stepShouldValidate bit,
			@stepMinValue varbinary(128),
			@stepMaxValue varbinary(128),
			@mappingIdFromValidate uniqueidentifier

	while (@stepIndex <= @stepsCount)
	begin
		select 
			@currentStep = x.query('(./Step[@Id = sql:variable("@stepIndex")])[1]') 
		from 
			@input.nodes('/BulkOperationShardMappingsGlobal/Steps') as t(x)

		select
			@stepType = x.value('(@Kind)[1]', 'int'),
			@stepMappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier')
		from
			@currentStep.nodes('./Step') as t(x)
	
		if (@stepType is null or @stepMappingId is null)
			goto Error_MissingParameters;

		if (@stepType = 1)
		begin

			select 
				@stepLockOwnerId = x.value('(Lock/Id)[1]', 'uniqueidentifier')
			from 
				@currentStep.nodes('./Step') as t(x)

			if (@stepLockOwnerId is null)
				goto Error_MissingParameters;

			select 
				@currentLockOwnerId = LockOwnerId,
				@currentStatus = Status
			from
				__ShardManagement.ShardMappingsGlobal with (updlock)
			where
				ShardMapId = @shardMapId and MappingId = @stepMappingId and Readable = 1

			if (@currentLockOwnerId is null)	
				goto Error_MappingDoesNotExist;

			if (@currentLockOwnerId <> @stepLockOwnerId)
				goto Error_MappingLockOwnerIdMismatch;

			if ((@currentStatus & 1) <> 0 and 
				(@operationCode = 5 or 
					@operationCode = 9 or 
					@operationCode = 13))
				goto Error_MappingIsNotOffline;

			update 
				__ShardManagement.ShardMappingsGlobal
			set
				OperationId = @operationId
			where
				ShardMapId = @shardMapId and MappingId = @stepMappingId

			set @currentLockOwnerId = null
			set @currentStatus = null
		end
		else
		if (@stepType = 2)
		begin

			select 
				@stepLockOwnerId = x.value('(Lock/Id)[1]', 'uniqueidentifier'),
				@stepStatus = x.value('(Update/Mapping/Status)[1]', 'int')
			from 
				@currentStep.nodes('./Step') as t(x)

			if (@stepLockOwnerId is null or @stepStatus is null)
				goto Error_MissingParameters;

			select
				@currentLockOwnerId = LockOwnerId,
				@currentStatus = Status
			from
				__ShardManagement.ShardMappingsGlobal with (updlock)
			where
				ShardMapId = @shardMapId and MappingId = @stepMappingId and Readable = 1

			if (@currentLockOwnerId is null)	
				goto Error_MappingDoesNotExist;

			if (@currentLockOwnerId <> @stepLockOwnerId)
				goto Error_MappingLockOwnerIdMismatch;

			if ((@currentStatus & 1) = 1 and (@stepStatus & 1) = 1 and @shardIdForRemoves <> @shardIdForAdds)
				goto Error_MappingIsNotOffline;

			update 
				__ShardManagement.ShardMappingsGlobal
			set
				OperationId = @operationId
			where
				ShardMapId = @shardMapId and MappingId = @stepMappingId

			set @currentLockOwnerId = null
			set @currentStatus = null

			set @stepStatus = null
		end
		else
		if (@stepType = 3)
		begin
			select 
				@stepShouldValidate = x.value('(@Validate)[1]', 'bit'),
				@stepMappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier'),
				@stepMinValue = convert(varbinary(128), x.value('(Mapping/MinValue)[1]', 'varchar(258)'), 1),
				@stepMaxValue = convert(varbinary(128), x.value('(Mapping/MaxValue[@Null="0"])[1]', 'varchar(258)'), 1),
				@stepStatus = x.value('(Mapping/Status)[1]', 'int'),
				@stepLockOwnerId = x.value('(Mapping/LockOwnerId)[1]', 'uniqueidentifier')
			from
				@currentStep.nodes('./Step') as t(x)

			if (@stepShouldValidate is null or @stepMappingId is null or @stepMinValue is null or @stepStatus is null or @stepLockOwnerId is null)
				goto Error_MissingParameters;

			if (@stepShouldValidate = 1)
			begin
				if (@shardMapType = 1)
				begin
					select 
						@mappingIdFromValidate = MappingId,
						@currentShardOperationId = OperationId
					from
					__ShardManagement.ShardMappingsGlobal
					where
						ShardMapId = @shardMapId and
						MinValue = @stepMinValue

					if (@mappingIdFromValidate is not null)
					begin
						if (@currentShardOperationId is null or @currentShardOperationId = @operationId)
							goto Error_PointAlreadyMapped;
						else
							goto Error_ShardPendingOperation;
					end
				end
				else
				begin
					select 
						@mappingIdFromValidate = MappingId,
						@currentShardOperationId = OperationId
					from
						__ShardManagement.ShardMappingsGlobal
					where
						ShardMapId = @shardMapId and
						(MaxValue is null or MaxValue > @stepMinValue) and 
						(@stepMaxValue is null or MinValue < @stepMaxValue)

					if (@mappingIdFromValidate is not null)
					begin
						if (@currentShardOperationId is null or @currentShardOperationId = @operationId)
							goto Error_RangeAlreadyMapped;
						else
							goto Error_ShardPendingOperation;
					end
				end
			end

			insert into
				__ShardManagement.ShardMappingsGlobal(
				MappingId, 
				Readable,
				ShardId, 
				ShardMapId, 
				OperationId, 
				MinValue, 
				MaxValue, 
				Status,
				LockOwnerId)
			values (
				@stepMappingId, 
				0,
				@shardIdForAdds, 
				@shardMapId, 
				@operationId, 
				@stepMinValue, 
				@stepMaxValue, 
				@stepStatus,
				@stepLockOwnerId)

			set @stepStatus = null

			set @stepShouldValidate = null
			set @stepMinValue = null
			set @stepMaxValue = null
			set @mappingIdFromValidate = null
		end

		set @stepType = null
		set @stepMappingId = null
		set @stepLockOwnerId = null

		set @stepIndex = @stepIndex + 1
	end

	goto Success_Exit;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_ShardDoesNotExist:
	set @result = 202
	goto Exit_Procedure;

Error_MappingDoesNotExist:
	set @result = 301
	goto Exit_Procedure;

Error_RangeAlreadyMapped:
	set @result = 302
	goto Exit_Procedure;

Error_PointAlreadyMapped:
	set @result = 303
	goto Exit_Procedure;

Error_MappingLockOwnerIdMismatch:
	set @result = 307
	goto Exit_Procedure;

Error_MappingIsNotOffline:
	set @result = 306
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_ShardPendingOperation:
	set @result = 52
	exec __ShardManagement.spGetOperationLogEntryGlobalHelper @currentShardOperationId
	goto Exit_Procedure;

Error_UnexpectedError:
	set @result = 53
	goto Exit_Procedure;

Success_Exit:
	set @result = 1
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spBulkOperationShardMappingsGlobalBegin] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spBulkOperationShardMappingsGlobalEnd]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@operationCode int,
			@undo int,
			@stepsCount int,
			@shardMapId uniqueidentifier

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@operationCode = x.value('(@OperationCode)[1]', 'int'),
		@undo = x.value('(@Undo)[1]', 'int'),
		@stepsCount = x.value('(@StepsCount)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier')
	from
		@input.nodes('/BulkOperationShardMappingsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @operationId is null or @operationCode is null or @undo is null or
		@stepsCount is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if not exists (
		select 
			ShardMapId 
		from 
			__ShardManagement.ShardMapsGlobal with (updlock)
		where
			ShardMapId = @shardMapId)
		goto Error_ShardMapNotFound;

	declare @shardIdForRemoves uniqueidentifier,
			@shardVersionForRemoves uniqueidentifier,
			@shardIdForAdds uniqueidentifier,
			@shardVersionForAdds uniqueidentifier

	select 
		@shardIdForRemoves = x.value('(Removes/Shard/Id)[1]', 'uniqueidentifier'),
		@shardIdForAdds = x.value('(Adds/Shard/Id)[1]', 'uniqueidentifier'),
		@shardVersionForRemoves = x.value('(Removes/Shard/Version)[1]', 'uniqueidentifier'),
		@shardVersionForAdds = x.value('(Adds/Shard/Version)[1]', 'uniqueidentifier')
	from 
		@input.nodes('/BulkOperationShardMappingsGlobal') as t(x)

	if (@shardIdForRemoves is null or @shardIdForAdds is null or @shardVersionForRemoves is null or @shardVersionForAdds is null)
		goto Error_MissingParameters;

	if (@undo = 1)
	begin
		update 
			__ShardManagement.ShardsGlobal
		set
			OperationId = null
		where
			ShardMapId = @shardMapId and ShardId = @shardIdForRemoves

		if (@shardIdForRemoves <> @shardIdForAdds)
		begin
			update 
				__ShardManagement.ShardsGlobal
			set
				OperationId = null
			where
				ShardMapId = @shardMapId and ShardId = @shardIdForAdds
		end
	end
	else
	begin
		update 
			__ShardManagement.ShardsGlobal
		set
			Version = @shardVersionForRemoves,
			OperationId = null
		where
			ShardMapId = @shardMapId and ShardId = @shardIdForRemoves

		if (@shardIdForRemoves <> @shardIdForAdds)
		begin
		update 
			__ShardManagement.ShardsGlobal
		set
			Version = @shardVersionForAdds,
			OperationId = null
		where
			ShardMapId = @shardMapId and ShardId = @shardIdForAdds
		end
	end

	declare @currentStep xml,
			@stepIndex int = 1,
			@stepType int,
			@stepMappingId uniqueidentifier
	
	while (@stepIndex <= @stepsCount)
	begin
		select 
			@currentStep = x.query('(./Step[@Id = sql:variable("@stepIndex")])[1]') 
		from
		@input.nodes('/BulkOperationShardMappingsGlobal/Steps') as t(x)

		select 
			@stepType = x.value('(@Kind)[1]', 'int'),
			@stepMappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier')
		from
			@currentStep.nodes('./Step') as t(x)

		if (@stepType is null or @stepMappingId is null)
			goto Error_MissingParameters;

		if (@stepType = 1)
		begin
			if (@undo = 1)
			begin
				update 
					__ShardManagement.ShardMappingsGlobal
				set
					OperationId = null
				where
					ShardMapId = @shardMapId and MappingId = @stepMappingId
			end
			else
			begin
				delete from 
					__ShardManagement.ShardMappingsGlobal
				where
					ShardMapId = @shardMapId and MappingId = @stepMappingId
			end
		end
		else
		if (@stepType = 2)
		begin
			declare @newMappingId uniqueidentifier,
					@newMappingStatus int

			if (@undo = 1)
			begin
				update 
					__ShardManagement.ShardMappingsGlobal
				set
					OperationId = null
				where
					ShardMapId = @shardMapId and MappingId = @stepMappingId
			end
			else
			begin
				select
					@newMappingId = x.value('(Update/Mapping/Id)[1]', 'uniqueidentifier'),
					@newMappingStatus = x.value('(Update/Mapping/Status)[1]', 'int')
				from
					@currentStep.nodes('./Step') as t(x)

				update 
					__ShardManagement.ShardMappingsGlobal
				set
					MappingId = @newMappingId,
					ShardId = @shardIdForAdds,
					Status = @newMappingStatus,
					OperationId = null
				where
					ShardMapId = @shardMapId and MappingId = @stepMappingId
			end

			set @newMappingId = null
			set @newMappingStatus = null
		end
		else
		if (@stepType = 3)
		begin
			if (@undo = 1)
			begin
				delete from 
					__ShardManagement.ShardMappingsGlobal
				where
					ShardMapId = @shardMapId and MappingId = @stepMappingId
			end
			else
			begin
				update 
					__ShardManagement.ShardMappingsGlobal
				set
					Readable = 1,
					OperationId = null
				where
					ShardMapId = @shardMapId and MappingId = @stepMappingId
			end
		end

		set @stepMappingId = null

		set @stepIndex = @stepIndex + 1
	end

	delete from 
		__ShardManagement.OperationsLogGlobal
	where
		OperationId = @operationId

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spBulkOperationShardMappingsGlobalEnd] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spBulkOperationShardsGlobalBegin]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@operationCode int,
			@stepsCount int,
			@shardMapId uniqueidentifier

	select 
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@operationCode = x.value('(@OperationCode)[1]', 'int'),
		@stepsCount = x.value('(@StepsCount)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier')
	from
		@input.nodes('/BulkOperationShardsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @operationId is null or @operationCode is null or 
		@stepsCount is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if not exists (
		select 
			ShardMapId 
		from 
			__ShardManagement.ShardMapsGlobal with (updlock)
		where
			ShardMapId = @shardMapId)
		goto Error_ShardMapNotFound;

	begin try
		insert into __ShardManagement.OperationsLogGlobal(
			OperationId,
			OperationCode,
			Data,
			ShardVersionRemoves,
			ShardVersionAdds)
		values (
			@operationId,
			@operationCode,
			@input,
			null,
			null)
	end try
	begin catch
		if (error_number() <> 2627)
		begin
			declare @errorMessage nvarchar(max) = error_message(),
					@errorNumber int = error_number(),
					@errorSeverity int = error_severity(),
					@errorState int = error_state(),
					@errorLine int = error_line(),
					@errorProcedure nvarchar(128) = isnull(error_procedure(), '-');

			select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage;
			
			raiserror (@errorMessage, @errorSeverity, 1, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			
			rollback transaction; -- To avoid extra error message in response.
			goto Error_UnexpectedError;
		end
	end catch

	declare @currentStep xml,
			@stepIndex int = 1,
			@stepType int,
			@stepShardId uniqueidentifier,
			@stepShardVersion uniqueidentifier,
			@currentShardVersion uniqueidentifier,
			@currentShardOperationId uniqueidentifier

	declare	@stepProtocol int,
			@stepServerName nvarchar(128),
			@stepPort int,
			@stepDatabaseName nvarchar(128),
			@stepShardStatus int

	while (@stepIndex <= @stepsCount)
	begin
		select 
			@currentStep = x.query('(./Step[@Id = sql:variable("@stepIndex")])[1]') 
		from
			@input.nodes('/BulkOperationShardsGlobal/Steps') as t(x)

		select 
			@stepType = x.value('(@Kind)[1]', 'int'),
			@stepShardId = x.value('(Shard/Id)[1]', 'uniqueidentifier'),
			@stepShardVersion = x.value('(Shard/Version)[1]', 'uniqueidentifier')
		from 
			@currentStep.nodes('./Step') as t(x)

		if (@stepType is null or @stepShardId is null or @stepShardVersion is null)
			goto Error_MissingParameters;

		if (@stepType = 1 or @stepType = 2)
		begin

			select
				@currentShardVersion = Version,
				@currentShardOperationId = OperationId
			from
				__ShardManagement.ShardsGlobal with (updlock)
			where
				ShardMapId = @shardMapId and ShardId = @stepShardId and Readable = 1

			if (@currentShardOperationId = @operationId)
				goto Success_Exit;

			if (@currentShardOperationId is not null)
				goto Error_ShardPendingOperation;

			if (@currentShardVersion is null)
				goto Error_ShardDoesNotExist;

			if (@currentShardVersion <> @stepShardVersion)
				goto Error_ShardVersionMismatch;

			if (@stepType = 1)
			begin
			if exists (
				select 
					ShardId 
				from 
					__ShardManagement.ShardMappingsGlobal 
				where 
					ShardMapId = @shardMapId and ShardId = @stepShardId)
				goto Error_ShardHasMappings;
			end

			update 
				__ShardManagement.ShardsGlobal
			set
				OperationId = @operationId
			where
				ShardMapId = @shardMapId and ShardId = @stepShardId
		end
		else
		if (@stepType = 3)
		begin

			select
				@stepProtocol = x.value('(Shard/Location/Protocol)[1]', 'int'),
				@stepServerName = x.value('(Shard/Location/ServerName)[1]', 'nvarchar(128)'),
				@stepPort = x.value('(Shard/Location/Port)[1]', 'int'),
				@stepDatabaseName = x.value('(Shard/Location/DatabaseName)[1]', 'nvarchar(128)'),
				@stepShardStatus = x.value('(Shard/Status)[1]', 'int')
			from
				@currentStep.nodes('./Step') as t(x)

			if (@stepProtocol is null or @stepServerName is null or @stepPort is null or @stepDatabaseName is null or @stepShardStatus is null)
				goto Error_MissingParameters;

			select 
				@currentShardVersion = Version,
				@currentShardOperationId = OperationId
			from
				__ShardManagement.ShardsGlobal with (updlock)
			where
				ShardMapId = @shardMapId and ShardId = @stepShardId

			if (@currentShardOperationId = @operationId)
				goto Success_Exit;

			if (@currentShardOperationId is not null)
				goto Error_ShardPendingOperation;
	
			if (@currentShardVersion is not null)
				goto Error_ShardAlreadyExists;

			set @currentShardVersion = null
			set @currentShardOperationId = null

			select 
				@currentShardVersion = Version, 
				@currentShardOperationId = OperationId
			from  
				__ShardManagement.ShardsGlobal 
			where
				ShardMapId = @shardMapId and
				Protocol = @stepProtocol and 
				ServerName = @stepServerName and
				Port = @stepPort and
				DatabaseName = @stepDatabaseName

			if (@currentShardOperationId is not null)
				goto Error_ShardPendingOperation;

			if (@currentShardVersion is not null)
				goto Error_ShardLocationAlreadyExists;

			begin try
				insert into 
					__ShardManagement.ShardsGlobal(
					ShardId, 
					Readable, 
					Version, 
					ShardMapId, 
					OperationId, 
					Protocol, 
					ServerName, 
					Port, 
					DatabaseName, 
					Status)
				values (
					@stepShardId, 
					0,
					@stepShardVersion, 
					@shardMapId,
					@operationId, 
					@stepProtocol, 
					@stepServerName, 
					@stepPort, 
					@stepDatabaseName, 
					@stepShardStatus) 
			end try
			begin catch
				if (error_number() = 2627)
					goto Error_ShardLocationAlreadyExists;
				else
				begin
					set @errorMessage = error_message()
					set	@errorNumber = error_number()
					set @errorSeverity = error_severity()
					set @errorState = error_state()
					set @errorLine = error_line()
					set @errorProcedure = isnull(error_procedure(), '-')

					select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage;
			
					raiserror (@errorMessage, @errorSeverity, 2, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			
					rollback transaction; -- To avoid extra error message in response.
					goto Error_UnexpectedError;
				end
			end catch

			set @stepProtocol = null
			set @stepServerName = null
			set @stepPort = null
			set @stepDatabaseName = null
			set @stepShardStatus = null
		end

		set @stepType = null
		set @stepShardId = null
		set @stepShardVersion = null
		set @currentShardVersion = null
		set @currentShardOperationId = null

		set @stepIndex = @stepIndex + 1
	end

	goto Success_Exit;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_ShardAlreadyExists:
	set @result = 201
	goto Exit_Procedure;

Error_ShardDoesNotExist:
	set @result = 202
	goto Exit_Procedure;

Error_ShardHasMappings:
	set @result = 203
	goto Exit_Procedure;

Error_ShardVersionMismatch:
	set @result = 204
	goto Exit_Procedure;

Error_ShardLocationAlreadyExists:
	set @result = 205
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_ShardPendingOperation:
	set @result = 52
	exec __ShardManagement.spGetOperationLogEntryGlobalHelper @currentShardOperationId
	goto Exit_Procedure;

Error_UnexpectedError:
	set @result = 53
	goto Exit_Procedure;

Success_Exit:
	set @result = 1
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spBulkOperationShardsGlobalBegin] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spBulkOperationShardsGlobalEnd]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int, 
			@gsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@operationCode int,
			@undo bit,
			@stepsCount int,
			@shardMapId uniqueidentifier

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@operationCode = x.value('(@OperationCode)[1]', 'int'),
		@undo = x.value('(@Undo)[1]', 'bit'),
		@stepsCount = x.value('(@StepsCount)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier')
	from
		@input.nodes('/BulkOperationShardsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @operationId is null or @operationCode is null or @undo is null or
		@stepsCount is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if not exists (
		select 
			ShardMapId 
		from 
			__ShardManagement.ShardMapsGlobal with (updlock)
		where
			ShardMapId = @shardMapId)
		goto Error_ShardMapNotFound;

	declare @currentStep xml,
			@stepIndex int = 1,
			@stepType int,
			@stepShardId uniqueidentifier
	
	while (@stepIndex <= @stepsCount)
	begin
		select 
			@currentStep = x.query('(./Step[@Id = sql:variable("@stepIndex")])[1]') 
		from
			@input.nodes('/BulkOperationShardsGlobal/Steps') as t(x)

		select 
			@stepType = x.value('(@Kind)[1]', 'int'),
			@stepShardId = x.value('(Shard/Id)[1]', 'uniqueidentifier')
		from 
			@currentStep.nodes('./Step') as t(x)

		if (@stepType is null or @stepShardId is null)
			goto Error_MissingParameters;

		if (@stepType = 1)
		begin
			if (@undo = 1)
			begin
				update 
					__ShardManagement.ShardsGlobal
				set
					OperationId = null
				where
					ShardMapId = @shardMapId and ShardId = @stepShardId and OperationId = @operationId 
			end
			else
			begin
				delete from 
					__ShardManagement.ShardsGlobal
				where
					ShardMapId = @shardMapId and ShardId = @stepShardId and OperationId = @operationId
			end
		end
		else
		if (@stepType = 2)
		begin
			declare @newShardVersion uniqueidentifier,
					@newStatus int

			if (@undo = 1)
			begin
				update 
					__ShardManagement.ShardsGlobal
				set
					OperationId = null
				where
					ShardMapId = @shardMapId and ShardId = @stepShardId and OperationId = @operationId 
			end
			else
			begin
				select 
					@newShardVersion = x.value('(Update/Shard/Version)[1]', 'uniqueidentifier'),
					@newStatus = x.value('(Update/Shard/Status)[1]', 'int')
				from 
					@currentStep.nodes('./Step') as t(x)

				update 
					__ShardManagement.ShardsGlobal
				set
					Version = @newShardVersion,
					Status = @newStatus,
					OperationId = null
				where
					ShardMapId = @shardMapId and ShardId = @stepShardId and OperationId = @operationId 
			end

			set @newShardVersion = null
			set @newStatus = null
		end
		else
		if (@stepType = 3)
		begin
			if (@undo = 1)
			begin
				delete from 
					__ShardManagement.ShardsGlobal
				where
					ShardMapId = @shardMapId and ShardId = @stepShardId and OperationId = @operationId
			end
			else
			begin
				update 
					__ShardManagement.ShardsGlobal
				set
					Readable = 1,
					OperationId = null
				where
					ShardMapId = @shardMapId and ShardId = @stepShardId and OperationId = @operationId 
			end
		end

		set @stepShardId = null

		set @stepIndex = @stepIndex + 1
	end

	delete from
		__ShardManagement.OperationsLogGlobal
	where 
		OperationId = @operationId

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spBulkOperationShardsGlobalEnd] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spDetachShardGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int, 
			@gsmVersionMinorClient int,
			@protocol int,
			@serverName nvarchar(128),
			@port int,
			@databaseName nvarchar(128),
			@name nvarchar(50)
	
	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@protocol = x.value('(Location/Protocol)[1]', 'int'),
		@serverName = x.value('(Location/ServerName)[1]', 'nvarchar(128)'),
		@port = x.value('(Location/Port)[1]', 'int'),
		@databaseName = x.value('(Location/DatabaseName)[1]', 'nvarchar(128)'),
		@name = x.value('(Shardmap[@Null="0"]/Name)[1]', 'nvarchar(50)')
	from
		@input.nodes('/DetachShardGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @protocol is null or @serverName is null or @port is null or @databaseName is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	declare @tvShardsToDetach table (ShardMapId uniqueidentifier, ShardId uniqueidentifier)

	insert into 
		@tvShardsToDetach
	select 
		tShardMaps.ShardMapId, tShards.ShardId
	from
		__ShardManagement.ShardMapsGlobal tShardMaps 
		join
		__ShardManagement.ShardsGlobal tShards
		on 
			tShards.ShardMapId = tShardMaps.ShardMapId and 
			tShards.Protocol = @protocol and
			tShards.ServerName = @serverName and 
			tShards.Port = @port and
			tShards.DatabaseName = @databaseName
	where
		@name is null or tShardMaps.Name = @name

	delete 
		tShardMappings 
	from
		__ShardManagement.ShardMappingsGlobal tShardMappings 
		join
		@tvShardsToDetach tShardsToDetach
		on 
		tShardsToDetach.ShardMapId = tShardMappings.ShardMapId and tShardsToDetach.ShardId = tShardMappings.ShardId

	delete 
		tShards
	from
		__ShardManagement.ShardsGlobal tShards 
		join
		@tvShardsToDetach tShardsToDetach
		on 
		tShardsToDetach.ShardMapId = tShards.ShardMapId and tShardsToDetach.ShardId = tShards.ShardId

	set @result = 1
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spDetachShardGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spFindAndUpdateOperationLogEntryByIdGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@undoStartState int

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@undoStartState = x.value('(@UndoStartState)[1]', 'int')
	from
		@input.nodes('/FindAndUpdateOperationLogEntryByIdGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @operationId is null or @undoStartState is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	update 
		__ShardManagement.OperationsLogGlobal
	set
		UndoStartState = @undoStartState
	where
		OperationId = @operationId

	set @result = 1
	exec __ShardManagement.spGetOperationLogEntryGlobalHelper @operationId
	goto Exit_Procedure;
	
Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spFindAndUpdateOperationLogEntryByIdGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spFindShardByLocationGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@protocol int,
			@serverName nvarchar(128),
			@port int,
			@databaseName nvarchar(128)

	select 
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@protocol = x.value('(Location/Protocol)[1]', 'int'),
		@serverName = x.value('(Location/ServerName)[1]', 'nvarchar(128)'),
		@port = x.value('(Location/Port)[1]', 'int'),
		@databaseName = x.value('(Location/DatabaseName)[1]', 'nvarchar(128)')
	from
		@input.nodes('/FindShardByLocationGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null or 
		@protocol is null or @serverName is null or @port is null or @databaseName is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if not exists (
	select 
		ShardMapId 
	from
		__ShardManagement.ShardMapsGlobal
	where
		ShardMapId = @shardMapId)
		goto Error_ShardMapNotFound;

	select 
		2, ShardId, Version, ShardMapId, Protocol, ServerName, Port, DatabaseName, Status
	from 
		__ShardManagement.ShardsGlobal 
	where
		ShardMapId = @shardMapId and
		Protocol = @protocol and ServerName = @serverName and Port = @port and DatabaseName = @databaseName and 
		Readable = 1

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spFindShardByLocationGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spFindShardingSchemaInfoByNameGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@name nvarchar(128)

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@name = x.value('(SchemaInfo/Name)[1]', 'nvarchar(128)')
	from 
		@input.nodes('/FindShardingSchemaInfoGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @name is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	select
		7, Name, SchemaInfo
	from 
		__ShardManagement.ShardedDatabaseSchemaInfosGlobal
	where
		Name = @name

	if (@@rowcount = 0)
		goto Error_SchemaInfoNameDoesNotExist;

	set @result = 1
	goto Exit_Procedure;

Error_SchemaInfoNameDoesNotExist:
	set @result = 401
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spFindShardingSchemaInfoByNameGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spFindShardMapByNameGlobal]
@input xml,
@result int output
as
begin
declare @gsmVersionMajorClient int,
	@gsmVersionMinorClient int,
			@name  nvarchar(50)

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@name = x.value('(ShardMap/Name)[1]', ' nvarchar(50)')
	from 
		@input.nodes('/FindShardMapByNameGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @name is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	select
		1, ShardMapId, Name, ShardMapType, KeyType
	from
		__ShardManagement.ShardMapsGlobal
	where 
		Name = @name

	set @result = 1
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spFindShardMapByNameGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spFindShardMappingByIdGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@mappingId uniqueidentifier

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@mappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier')
	from
		@input.nodes('/FindShardMappingByIdGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null or @mappingId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	declare @shardMapType int

	select 
		@shardMapType = ShardMapType
	from
		__ShardManagement.ShardMapsGlobal
	where
		ShardMapId = @shardMapId

	if (@shardMapType is null)
		goto Error_ShardMapNotFound;
		
	declare @currentShardId uniqueidentifier,
			@currentMinValue varbinary(128),
			@currentMaxValue varbinary(128),
			@currentStatus int,
			@currentLockOwnerId uniqueidentifier

	select
		@currentMinValue = MinValue
	from
		__ShardManagement.ShardMappingsGlobal
	where
		ShardMapId = @shardMapId and 
		Readable = 1 and
		MappingId = @mappingId

	if (@@rowcount = 0)
		goto Error_MappingDoesNotExist;

	select
		@currentShardId = ShardId,
		@currentMaxValue = MaxValue,
		@currentStatus = Status,
		@currentLockOwnerId = LockOwnerId
	from
		__ShardManagement.ShardMappingsGlobal
	where
		ShardMapId = @shardMapId and 
		MinValue = @currentMinValue

	if (@@rowcount = 0)
		goto Error_MappingDoesNotExist;

	select
		3, @mappingId as MappingId, ShardMapId, @currentMinValue, @currentMaxValue, @currentStatus, @currentLockOwnerId, -- fields for SqlMapping
		ShardId, Version, ShardMapId, Protocol, ServerName, Port, DatabaseName, Status -- fields for SqlShard, ShardMapId is repeated here
	from
		__ShardManagement.ShardsGlobal
	where
		ShardId = @currentShardId and
		ShardMapId = @shardMapId

	if (@@rowcount = 0)
		goto Error_MappingDoesNotExist;

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MappingDoesNotExist:
	set @result = 301
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spFindShardMappingByIdGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spFindShardMappingByKeyGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@keyValue varbinary(128)

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@keyValue = convert(varbinary(128), x.value('(Key/Value)[1]', 'varchar(258)'), 1)
	from
		@input.nodes('/FindShardMappingByKeyGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null or @keyValue is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	declare @shardMapType int

	select 
		@shardMapType = ShardMapType
	from
		__ShardManagement.ShardMapsGlobal
	where
		ShardMapId = @shardMapId

	if (@shardMapType is null)
		goto Error_ShardMapNotFound;
		
	declare @currentMappingId uniqueidentifier,
			@currentShardId uniqueidentifier,
			@currentMinValue varbinary(128),
			@currentMaxValue varbinary(128),
			@currentStatus int,
			@currentLockOwnerId uniqueidentifier

	if (@shardMapType = 1)
	begin	
		select
			@currentMappingId = MappingId,
			@currentShardId = ShardId,
			@currentMinValue = MinValue,
			@currentMaxValue = MaxValue,
			@currentStatus = Status,
			@currentLockOwnerId = LockOwnerId
		from
			__ShardManagement.ShardMappingsGlobal
		where
			ShardMapId = @shardMapId and 
			Readable = 1 and
			MinValue = @keyValue
	end
	else
	begin
		select 
			@currentMappingId = MappingId,
			@currentShardId = ShardId,
			@currentMinValue = MinValue,
			@currentMaxValue = MaxValue,
			@currentStatus = Status,
			@currentLockOwnerId = LockOwnerId
		from 
			__ShardManagement.ShardMappingsGlobal
		where
			ShardMapId = @shardMapId and 
			Readable = 1 and
			MinValue <= @keyValue and (MaxValue is null or MaxValue > @keyValue)
	end

	if (@@rowcount = 0)
		goto Error_KeyNotFound;

	select 
		3, @currentMappingId as MappingId, ShardMapId, @currentMinValue, @currentMaxValue, @currentStatus, @currentLockOwnerId, -- fields for SqlMapping
		ShardId, Version, ShardMapId, Protocol, ServerName, Port, DatabaseName, Status -- fields for SqlShard, ShardMapId is repeated here
	from 
		__ShardManagement.ShardsGlobal
	where
		ShardId = @currentShardId and
		ShardMapId = @shardMapId
	
	if (@@rowcount = 0)
		goto Error_KeyNotFound;

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_KeyNotFound:
	set @result = 304
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spFindShardMappingByKeyGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetAllDistinctShardLocationsGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int

	select 
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int')
	from 
		@input.nodes('/GetAllDistinctShardLocationsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	select distinct 
		4, Protocol, ServerName, Port, DatabaseName 
	from 
		__ShardManagement.ShardsGlobal
	where
		Readable = 1

	set @result = 1
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetAllDistinctShardLocationsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetAllShardingSchemaInfosGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int')
	from 
		@input.nodes('/GetAllShardingSchemaInfosGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	select
		7, Name, SchemaInfo
	from
		__ShardManagement.ShardedDatabaseSchemaInfosGlobal

	set @result = 1
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetAllShardingSchemaInfosGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetAllShardMappingsGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int, 
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@shardId uniqueidentifier,
			@shardVersion uniqueidentifier,
			@minValue varbinary(128),
			@maxValue varbinary(128)

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@shardId = x.value('(Shard[@Null="0"]/Id)[1]', 'uniqueidentifier'),
		@shardVersion = x.value('(Shard[@Null="0"]/Version)[1]', 'uniqueidentifier'),
		@minValue = convert(varbinary(128), x.value('(Range[@Null="0"]/MinValue)[1]', 'varchar(258)'), 1),
		@maxValue = convert(varbinary(128), x.value('(Range[@Null="0"]/MaxValue[@Null="0"])[1]', 'varchar(258)'), 1)
	from
		@input.nodes('/GetAllShardMappingsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	declare @shardMapType int

	select 
		@shardMapType = ShardMapType
	from
		__ShardManagement.ShardMapsGlobal
	where
		ShardMapId = @shardMapId

	if (@shardMapType is null)
		goto Error_ShardMapNotFound;

	declare @currentShardVersion uniqueidentifier

	if (@shardId is not null)
	begin
		if (@shardVersion is null)
			goto Error_MissingParameters;
			
		select 
			@currentShardVersion = Version
		from
			__ShardManagement.ShardsGlobal
		where
			ShardMapId = @shardMapId and ShardId = @shardId and Readable = 1

		if (@currentShardVersion is null)
			goto Error_ShardDoesNotExist;

	end
			
	declare @tvShards table (
		ShardId uniqueidentifier not null, 
		Version uniqueidentifier not null, 
		Protocol int not null,
		ServerName nvarchar(128) collate SQL_Latin1_General_CP1_CI_AS not null, 
		Port int not null,
		DatabaseName nvarchar(128) collate SQL_Latin1_General_CP1_CI_AS not null, 
		Status int not null,
		primary key (ShardId)
	)

	insert into
		@tvShards
	select
		ShardId = s.ShardId,
		Version = s.Version,
		Protocol = s.Protocol,
		ServerName = s.ServerName,
		Port = s.Port,
		DatabaseName = s.DatabaseName,
		Status = s.Status
	from
		__ShardManagement.ShardsGlobal s
	where
		(@shardId is null or s.ShardId = @shardId) and s.ShardMapId = @shardMapId
		

	declare @minValueCalculated varbinary(128) = 0x,
			@maxValueCalculated varbinary(128) = null

	if (@minValue is not null)
		set @minValueCalculated = @minValue

	if (@maxValue is not null)
		set @maxValueCalculated = @maxValue

	if (@shardMapType = 1)
	begin
		select
			3, m.MappingId, m.ShardMapId, m.MinValue, m.MaxValue, m.Status, m.LockOwnerId,  -- fields for SqlMapping
			s.ShardId, s.Version, m.ShardMapId, s.Protocol, s.ServerName, s.Port, s.DatabaseName, s.Status -- fields for SqlShard, ShardMapId is repeated here
		from
			__ShardManagement.ShardMappingsGlobal m
		join 
			@tvShards s 
		on 
			m.ShardId = s.ShardId
		where
			m.ShardMapId = @shardMapId and 
			m.Readable = 1 and
			(@shardId is null or m.ShardId = @shardId) and 
			MinValue >= @minValueCalculated and 
			((@maxValueCalculated is null) or (MinValue < @maxValueCalculated))
		order by 
			m.MinValue
	end
	else
	begin
		select
			3, m.MappingId, m.ShardMapId, m.MinValue, m.MaxValue, m.Status, m.LockOwnerId,  -- fields for SqlMapping
			s.ShardId, s.Version, m.ShardMapId, s.Protocol, s.ServerName, s.Port, s.DatabaseName, s.Status -- fields for SqlShard, ShardMapId is repeated here
		from
			__ShardManagement.ShardMappingsGlobal m
		join 
			@tvShards s 
		on 
			m.ShardId = s.ShardId
		where
			m.ShardMapId = @shardMapId and 
			m.Readable = 1 and
			(@shardId is null or m.ShardId = @shardId) and 
			((MaxValue is null) or (MaxValue > @minValueCalculated)) and 
			((@maxValueCalculated is null) or (MinValue < @maxValueCalculated))
		order by
			m.MinValue
	end

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_ShardDoesNotExist:
	set @result = 202
	goto Exit_Procedure;


Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetAllShardMappingsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetAllShardMapsGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int

	select 
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int')
	from 
		@input.nodes('/GetAllShardMapsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	select 
		1, ShardMapId, Name, ShardMapType, KeyType 
	from 
		__ShardManagement.ShardMapsGlobal

	set @result = 1
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetAllShardMapsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetAllShardsGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier

	select 
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier')
	from 
		@input.nodes('/GetAllShardsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if not exists (
		select 
			ShardMapId 
		from 
			__ShardManagement.ShardMapsGlobal 
		where 
			ShardMapId = @shardMapId)
		goto Error_ShardMapNotFound;

	select 
		2, ShardId, Version, ShardMapId, Protocol, ServerName, Port, DatabaseName, Status
	from 
		__ShardManagement.ShardsGlobal 
	where 
		ShardMapId = @shardMapId and Readable = 1

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetAllShardsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetOperationLogEntryGlobalHelper]
@operationId uniqueidentifier
as
begin
	select
		6, OperationId, OperationCode, Data, UndoStartState, ShardVersionRemoves, ShardVersionAdds
	from
		__ShardManagement.OperationsLogGlobal
	where
		OperationId = @operationId
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetOperationLogEntryGlobalHelper] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetStoreVersionGlobalHelper]
as
begin
	select
		5, StoreVersionMajor, StoreVersionMinor
	from 
		__ShardManagement.ShardMapManagerGlobal
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetStoreVersionGlobalHelper] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [__ShardManagement].[spLockOrUnlockShardMappingsGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int, 
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@mappingId uniqueidentifier,
			@lockOwnerId uniqueidentifier,
			@lockOperationType int

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@mappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier'),
		@lockOwnerId = x.value('(Lock/Id)[1]', 'uniqueidentifier'),
		@lockOperationType = x.value('(Lock/Operation)[1]', 'int')
	from
		@input.nodes('/LockOrUnlockShardMappingsGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null or @lockOwnerId is null or @lockOperationType is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if (@lockOperationType < 2 and @mappingId is null)
		goto Error_MissingParameters;

	if not exists (
		select 
			ShardMapId 
		from 
			__ShardManagement.ShardMapsGlobal with (updlock)
		where
			ShardMapId = @shardMapId)
		goto Error_ShardMapNotFound;

	declare @DefaultLockOwnerId uniqueidentifier = '00000000-0000-0000-0000-000000000000',
			@currentOperationId uniqueidentifier

	if (@lockOperationType < 2)
	begin			
		declare @ForceUnLockLockOwnerId uniqueidentifier = 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF',
				@currentLockOwnerId uniqueidentifier

		select 
			@currentOperationId = OperationId,
			@currentLockOwnerId = LockOwnerId
		from 
			__ShardManagement.ShardMappingsGlobal with (updlock)
		where
			ShardMapId = @shardMapId and MappingId = @mappingId

		if (@currentLockOwnerId is null)
			goto Error_MappingDoesNotExist;

		if (@currentOperationId is not null)
			goto Error_ShardPendingOperation;

		if(@lockOperationType = 0 and @currentLockOwnerId <> @DefaultLockOwnerId)
			goto Error_MappingAlreadyLocked;

		if (@lockOperationType = 1 and (@lockOwnerId <> @currentLockOwnerId) and (@lockOwnerId <> @ForceUnLockLockOwnerId))
			goto Error_MappingLockOwnerIdMismatch;
	end

	update
		__ShardManagement.ShardMappingsGlobal
	set 
		LockOwnerId = case 
		when 
			@lockOperationType = 0 
		then 
			@lockOwnerId 
		when  
			@lockOperationType = 1 or @lockOperationType = 2 or @lockOperationType = 3
		then 
			@DefaultLockOwnerId 
		end
		where
			ShardMapId = @shardMapId and (@lockOperationType = 3 or -- unlock all mappings
										  (@lockOperationType = 2 and LockOwnerId = @lockOwnerId) or -- unlock all mappings for specified LockOwnerId
										  MappingId = @mappingId) -- lock/unlock specified mapping with specified LockOwnerId

Success_Exit:
	set @result = 1 -- success
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MappingDoesNotExist:
	set @result = 301
	goto Exit_Procedure;

Error_MappingLockOwnerIdMismatch:
	set @result = 307
	goto Exit_Procedure;

Error_MappingAlreadyLocked:
	set @result = 308
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_ShardPendingOperation:
	set @result = 52
	exec __ShardManagement.spGetOperationLogEntryGlobalHelper @currentOperationId
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spLockOrUnlockShardMappingsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spRemoveShardingSchemaInfoGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@name nvarchar(128)

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@name = x.value('(SchemaInfo/Name)[1]', 'nvarchar(128)')
	from 
		@input.nodes('/RemoveShardingSchemaInfoGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @name is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	delete from
		__ShardManagement.ShardedDatabaseSchemaInfosGlobal
	where
		Name = @name

	if (@@rowcount = 0)
		goto Error_SchemaInfoNameDoesNotExist;

	set @result = 1
	goto Exit_Procedure;

Error_SchemaInfoNameDoesNotExist:
	set @result = 401
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spRemoveShardingSchemaInfoGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spRemoveShardMapGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@shardMapId uniqueidentifier

	select 
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'),
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', ' uniqueidentifier')
	from 
		@input.nodes('/RemoveShardMapGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	declare @currentShardMapId uniqueidentifier

	select 
		@currentShardMapId = ShardMapId
	from
		__ShardManagement.ShardMapsGlobal with (updlock)
	where
		ShardMapId = @shardMapId

	if (@currentShardMapId is null)
		goto Error_ShardMapNotFound;

	if exists (
		select 
			ShardId 
		from 
			__ShardManagement.ShardsGlobal 
		where 
			ShardMapId = @shardMapId)
		goto Error_ShardMapHasShards;

	delete from 
		__ShardManagement.ShardMapsGlobal 
	where 
		ShardMapId = @shardMapId 

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_ShardMapHasShards:
	set @result = 103
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spRemoveShardMapGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spReplaceShardMappingsGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int, 
			@gsmVersionMinorClient int,
			@removeStepsCount int,
			@addStepsCount int,
			@shardMapId uniqueidentifier
	
	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@removeStepsCount = x.value('(@RemoveStepsCount)[1]', 'int'),
		@addStepsCount = x.value('(@AddStepsCount)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier')
	from
		@input.nodes('ReplaceShardMappingsGlobal') as t(x)
	
	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @removeStepsCount is null or @addStepsCount is null or @shardMapId is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	if not exists (
		select 
			ShardMapId 
		from 
			__ShardManagement.ShardMapsGlobal with (updlock)
		where
			ShardMapId = @shardMapId)
		goto Error_ShardMapNotFound;

	declare	@stepShardId uniqueidentifier,
			@stepMappingId uniqueidentifier

	if (@removeStepsCount > 0)
	begin
		select 
			@stepShardId = x.value('(Shard/Id)[1]', 'uniqueidentifier')
		from 
			@input.nodes('ReplaceShardMappingsGlobal/RemoveSteps') as t(x)

		if (@stepShardId is null)
			goto Error_MissingParameters;
	
		declare @currentRemoveStep xml,
				@removeStepIndex int = 1

		while (@removeStepIndex <= @removeStepsCount)
		begin
			select 
				@currentRemoveStep = x.query('(./Step[@Id = sql:variable("@removeStepIndex")])[1]') 
			from
				@input.nodes('ReplaceShardMappingsGlobal/RemoveSteps') as t(x)

			select 
				@stepMappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier')
			from
				@currentRemoveStep.nodes('./Step') as t(x)

			if (@stepMappingId is null)
				goto Error_MissingParameters;

			delete from 
				__ShardManagement.ShardMappingsGlobal
			where
				ShardMapId = @shardMapId and MappingId = @stepMappingId and ShardId = @stepShardId

			set @stepMappingId = null

			set @removeStepIndex = @removeStepIndex + 1
		end

		set @stepShardId = null
	end

	if (@addStepsCount > 0)
	begin
		select 
			@stepShardId = x.value('(Shard/Id)[1]', 'uniqueidentifier')
		from 
			@input.nodes('ReplaceShardMappingsGlobal/AddSteps') as t(x)

		if (@stepShardId is null)
			goto Error_MissingParameters;

		declare @currentAddStep xml,
				@addStepIndex int = 1,
				@stepMinValue varbinary(128),
				@stepMaxValue varbinary(128),
				@stepStatus int
		
		while (@addStepIndex <= @addStepsCount)
		begin
			select 
				@currentAddStep = x.query('(./Step[@Id = sql:variable("@addStepIndex")])[1]') 
			from
				@input.nodes('ReplaceShardMappingsGlobal/AddSteps') as t(x)
		
			select
				@stepMappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier'),
				@stepMinValue = convert(varbinary(128), x.value('(Mapping/MinValue)[1]', 'varchar(258)'), 1),
				@stepMaxValue = convert(varbinary(128), x.value('(Mapping/MaxValue[@Null="0"])[1]', 'varchar(258)'), 1),
				@stepStatus = x.value('(Mapping/Status)[1]', 'int')
			from
				@currentAddStep.nodes('./Step') as t(x)
	
			if (@stepMappingId is null or @stepMinValue is null or @stepStatus is null)
				goto Error_MissingParameters;

			insert into
				__ShardManagement.ShardMappingsGlobal(
				MappingId, 
				Readable,
				ShardId, 
				ShardMapId, 
				OperationId, 
				MinValue, 
				MaxValue, 
				Status)
			values (
				@stepMappingId, 
				1,
				@stepShardId, 
				@shardMapId, 
				null, 
				@stepMinValue, 
				@stepMaxValue, 
				@stepStatus)

			set @stepMappingId = null
			set @stepMinValue = null
			set @stepMaxValue = null
			set @stepStatus = null

			set @addStepIndex = @addStepIndex + 1
		end
	end

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spReplaceShardMappingsGlobal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spUpdateShardingSchemaInfoGlobal]
@input xml,
@result int output
as
begin
	declare @gsmVersionMajorClient int,
			@gsmVersionMinorClient int,
			@name nvarchar(128),
			@schemaInfo xml

	select
		@gsmVersionMajorClient = x.value('(GsmVersion/MajorVersion)[1]', 'int'), 
		@gsmVersionMinorClient = x.value('(GsmVersion/MinorVersion)[1]', 'int'),
		@name = x.value('(SchemaInfo/Name)[1]', 'nvarchar(128)'),
		@schemaInfo = x.query('SchemaInfo/Info/*')
	from 
		@input.nodes('/UpdateShardingSchemaInfoGlobal') as t(x)

	if (@gsmVersionMajorClient is null or @gsmVersionMinorClient is null or @name is null or @schemaInfo is null)
		goto Error_MissingParameters;

	if (@gsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorGlobal())
		goto Error_GSMVersionMismatch;

	update 
		__ShardManagement.ShardedDatabaseSchemaInfosGlobal 
	set 
		SchemaInfo = @schemaInfo
	where
		Name = @name

	if (@@rowcount = 0)
		goto Error_SchemaInfoNameDoesNotExist;

	set @result = 1
	goto Exit_Procedure;

Error_SchemaInfoNameDoesNotExist:
	set @result = 401
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Error_GSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionGlobalHelper
	goto Exit_Procedure;

Exit_Procedure:
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spUpdateShardingSchemaInfoGlobal] TO  SCHEMA OWNER 
GO
