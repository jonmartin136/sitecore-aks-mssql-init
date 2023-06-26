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


create function [__ShardManagement].[fnGetStoreVersionMajorLocal]()
returns int
as
begin
	return (select StoreVersionMajor from __ShardManagement.ShardMapManagerLocal)
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[fnGetStoreVersionMajorLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMapManagerLocal](
	[StoreVersionMajor] [int] NOT NULL,
	[StoreVersionMinor] [int] NOT NULL,
 CONSTRAINT [pkShardMapManagerLocal_StoreVersionMajor] PRIMARY KEY CLUSTERED 
(
	[StoreVersionMajor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardMapManagerLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMappingsLocal](
	[MappingId] [uniqueidentifier] NOT NULL,
	[ShardId] [uniqueidentifier] NOT NULL,
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[MinValue] [varbinary](128) NOT NULL,
	[MaxValue] [varbinary](128) NULL,
	[Status] [int] NOT NULL,
	[LockOwnerId] [uniqueidentifier] NOT NULL,
	[LastOperationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pkShardMappingsLocal_MappingId] PRIMARY KEY CLUSTERED 
(
	[MappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardMappingsLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMapsLocal](
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MapType] [int] NOT NULL,
	[KeyType] [int] NOT NULL,
	[LastOperationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pkShardMapsLocal_ShardMapId] PRIMARY KEY CLUSTERED 
(
	[ShardMapId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardMapsLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardsLocal](
	[ShardId] [uniqueidentifier] NOT NULL,
	[Version] [uniqueidentifier] NOT NULL,
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[Protocol] [int] NOT NULL,
	[ServerName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Port] [int] NOT NULL,
	[DatabaseName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status] [int] NOT NULL,
	[LastOperationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pkShardsLocal_ShardId] PRIMARY KEY CLUSTERED 
(
	[ShardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
ALTER AUTHORIZATION ON [__ShardManagement].[ShardsLocal] TO  SCHEMA OWNER 
GO

INSERT [__ShardManagement].[ShardMapManagerLocal] ([StoreVersionMajor], [StoreVersionMinor]) VALUES (1, 2)
GO
INSERT [__ShardManagement].[ShardMappingsLocal] ([MappingId], [ShardId], [ShardMapId], [MinValue], [MaxValue], [Status], [LockOwnerId], [LastOperationId]) VALUES (N'4cb02d85-98bf-4810-b1eb-125fc90b3f56', N'e969a18c-f922-46d3-a51e-fadc58373fca', N'60c1f275-b533-41ec-8fd4-b791518bfa2f', 0x, 0x80, 1, N'00000000-0000-0000-0000-000000000000', N'01c2ca60-8f36-4ab3-bfdb-1fa0ac296731')
GO
INSERT [__ShardManagement].[ShardMappingsLocal] ([MappingId], [ShardId], [ShardMapId], [MinValue], [MaxValue], [Status], [LockOwnerId], [LastOperationId]) VALUES (N'a2071a40-792b-496a-8adb-2237a033734c', N'f7362703-e517-4a86-9577-14c9c365a3f8', N'd05a1cfc-644c-4ecb-9438-462172f69335', 0x, 0x80, 1, N'00000000-0000-0000-0000-000000000000', N'd86177ce-c7f8-49d1-b6fc-fe48b33c7565')
GO
INSERT [__ShardManagement].[ShardMappingsLocal] ([MappingId], [ShardId], [ShardMapId], [MinValue], [MaxValue], [Status], [LockOwnerId], [LastOperationId]) VALUES (N'c272a784-b721-411d-ba7b-323b3ff19fb4', N'f4ab4dd7-514c-49bc-b28a-be611531d3f5', N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', 0x, 0x80, 1, N'00000000-0000-0000-0000-000000000000', N'b9c83849-3e9f-481a-ada7-02036d4c0e53')
GO
INSERT [__ShardManagement].[ShardMapsLocal] ([ShardMapId], [Name], [MapType], [KeyType], [LastOperationId]) VALUES (N'd05a1cfc-644c-4ecb-9438-462172f69335', N'ContactIdentifiersIndexShardMap', 2, 4, N'7f13f8c4-ec9c-4b61-8a59-f1fd7a0fb654')
GO
INSERT [__ShardManagement].[ShardMapsLocal] ([ShardMapId], [Name], [MapType], [KeyType], [LastOperationId]) VALUES (N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', N'ContactIdShardMap', 2, 4, N'791ce608-a1b1-4862-a3e0-7424b0591c53')
GO
INSERT [__ShardManagement].[ShardMapsLocal] ([ShardMapId], [Name], [MapType], [KeyType], [LastOperationId]) VALUES (N'60c1f275-b533-41ec-8fd4-b791518bfa2f', N'DeviceProfileIdShardMap', 2, 4, N'628a5561-9a9c-4a6a-aeee-00b9e36fe806')
GO
INSERT [__ShardManagement].[ShardsLocal] ([ShardId], [Version], [ShardMapId], [Protocol], [ServerName], [Port], [DatabaseName], [Status], [LastOperationId]) VALUES (N'f7362703-e517-4a86-9577-14c9c365a3f8', N'99e168e2-0bc3-49ee-9a54-6e85af155751', N'd05a1cfc-644c-4ecb-9438-462172f69335', 0, N'$(ServerName)', 0, N'$(Shard0DbName)', 1, N'd86177ce-c7f8-49d1-b6fc-fe48b33c7565')
GO
INSERT [__ShardManagement].[ShardsLocal] ([ShardId], [Version], [ShardMapId], [Protocol], [ServerName], [Port], [DatabaseName], [Status], [LastOperationId]) VALUES (N'f4ab4dd7-514c-49bc-b28a-be611531d3f5', N'3e5af7e1-05ad-437f-86e0-80226bebee93', N'2f3b19e1-b9dd-463c-b4e5-8adc26147d64', 0, N'$(ServerName)', 0, N'$(Shard0DbName)', 1, N'b9c83849-3e9f-481a-ada7-02036d4c0e53')
GO
INSERT [__ShardManagement].[ShardsLocal] ([ShardId], [Version], [ShardMapId], [Protocol], [ServerName], [Port], [DatabaseName], [Status], [LastOperationId]) VALUES (N'e969a18c-f922-46d3-a51e-fadc58373fca', N'587b31e9-33d0-4afe-9083-6b6ed75a0793', N'60c1f275-b533-41ec-8fd4-b791518bfa2f', 0, N'$(ServerName)', 0, N'$(Shard0DbName)', 1, N'01c2ca60-8f36-4ab3-bfdb-1fa0ac296731')
GO
SET ANSI_PADDING ON

GO

ALTER TABLE [__ShardManagement].[ShardMappingsLocal] ADD  CONSTRAINT [ucShardMappingsLocal_ShardMapId_MinValue] UNIQUE NONCLUSTERED 
(
	[ShardMapId] ASC,
	[MinValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO

ALTER TABLE [__ShardManagement].[ShardsLocal] ADD  CONSTRAINT [ucShardsLocal_ShardMapId_Location] UNIQUE NONCLUSTERED 
(
	[ShardMapId] ASC,
	[Protocol] ASC,
	[ServerName] ASC,
	[DatabaseName] ASC,
	[Port] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO

ALTER TABLE [__ShardManagement].[ShardMappingsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LockOwnerId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LastOperationId]
GO
ALTER TABLE [__ShardManagement].[ShardMapsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LastOperationId]
GO
ALTER TABLE [__ShardManagement].[ShardsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LastOperationId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal]  WITH CHECK ADD  CONSTRAINT [fkShardMappingsLocal_ShardId] FOREIGN KEY([ShardId])
REFERENCES [__ShardManagement].[ShardsLocal] ([ShardId])
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal] CHECK CONSTRAINT [fkShardMappingsLocal_ShardId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal]  WITH CHECK ADD  CONSTRAINT [fkShardMappingsLocal_ShardMapId] FOREIGN KEY([ShardMapId])
REFERENCES [__ShardManagement].[ShardMapsLocal] ([ShardMapId])
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal] CHECK CONSTRAINT [fkShardMappingsLocal_ShardMapId]
GO
ALTER TABLE [__ShardManagement].[ShardsLocal]  WITH CHECK ADD  CONSTRAINT [fkShardsLocal_ShardMapId] FOREIGN KEY([ShardMapId])
REFERENCES [__ShardManagement].[ShardMapsLocal] ([ShardMapId])
GO
ALTER TABLE [__ShardManagement].[ShardsLocal] CHECK CONSTRAINT [fkShardsLocal_ShardMapId]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spAddShardLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int, 
			@lsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@undo int,
			@shardMapId uniqueidentifier,
			@shardId uniqueidentifier,
			@name nvarchar(50),
			@sm_kind int,
			@sm_keykind int,
			@shardVersion uniqueidentifier,
			@protocol int,
			@serverName nvarchar(128),
			@port int,
			@databaseName nvarchar(128),
			@shardStatus  int,
			@errorMessage nvarchar(max),
			@errorNumber int,
			@errorSeverity int,
			@errorState int,
			@errorLine int,
			@errorProcedure nvarchar(128)
	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'), 
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@undo = x.value('(@Undo)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@name = x.value('(ShardMap/Name)[1]', 'nvarchar(50)'),
		@sm_kind = x.value('(ShardMap/Kind)[1]', 'int'),
		@sm_keykind = x.value('(ShardMap/KeyKind)[1]', 'int'),
		@shardId = x.value('(Shard/Id)[1]', 'uniqueidentifier'),
		@shardVersion = x.value('(Shard/Version)[1]', 'uniqueidentifier'),
		@protocol = x.value('(Shard/Location/Protocol)[1]', 'int'),
		@serverName = x.value('(Shard/Location/ServerName)[1]', 'nvarchar(128)'),
		@port = x.value('(Shard/Location/Port)[1]', 'int'),
		@databaseName = x.value('(Shard/Location/DatabaseName)[1]', 'nvarchar(128)'),
		@shardStatus = x.value('(Shard/Status)[1]', 'int')
	from 
		@input.nodes('/AddShardLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @shardMapId is null or @operationId is null or @name is null or @sm_kind is null or @sm_keykind is null or 
		@shardId is null or @shardVersion is null or @protocol is null or @serverName is null or 
		@port is null or @databaseName is null or @shardStatus is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	if exists (
		select 
			ShardMapId
		from
			__ShardManagement.ShardMapsLocal
		where
			ShardMapId = @shardMapId and LastOperationId = @operationId)
		goto Success_Exit;

	begin try
		insert into 
			__ShardManagement.ShardMapsLocal 
			(ShardMapId, Name, MapType, KeyType, LastOperationId)
		values 
			(@shardMapId, @name, @sm_kind, @sm_keykind, @operationId)
	end try
	begin catch
	if (@undo != 1)
	begin
		set @errorMessage = error_message();
		set @errorNumber = error_number();
		set @errorSeverity = error_severity();
		set @errorState = error_state();
		set @errorLine = error_line();
		set @errorProcedure  = isnull(error_procedure(), '-');					
			select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage
			raiserror (@errorMessage, @errorSeverity, 1, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			rollback transaction; -- To avoid extra error message in response.
			goto Error_UnexpectedError;
	end
	end catch

	begin try
		insert into 
			__ShardManagement.ShardsLocal(
			ShardId, 
			Version, 
			ShardMapId, 
			Protocol, 
			ServerName, 
			Port, 
			DatabaseName, 
			Status,
			LastOperationId)
		values (
			@shardId, 
			@shardVersion, 
			@shardMapId,
			@protocol, 
			@serverName, 
			@port, 
			@databaseName, 
			@shardStatus,
			@operationId)
	end try
	begin catch
	if (@undo != 1)
	begin
		set @errorMessage = error_message();
		set @errorNumber = error_number();
		set @errorSeverity = error_severity();
		set @errorState = error_state();
		set @errorLine = error_line();
		set @errorProcedure  = isnull(error_procedure(), '-');
					
			select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage
			raiserror (@errorMessage, @errorSeverity, 1, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
			rollback transaction; -- To avoid extra error message in response.
			goto Error_UnexpectedError;
	end
	end catch 

	goto Success_Exit;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
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
ALTER AUTHORIZATION ON [__ShardManagement].[spAddShardLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spBulkOperationShardMappingsLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int,
			@lsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@operationCode int,
			@undo int,
			@stepsCount int,
			@shardMapId uniqueidentifier,
			@sm_kind int,
			@shardId uniqueidentifier,
			@shardVersion uniqueidentifier

	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@undo = x.value('(@Undo)[1]', 'int'),
		@stepsCount = x.value('(@StepsCount)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@shardId = x.value('(Shard/Id)[1]', 'uniqueidentifier'),
		@shardVersion = x.value('(Shard/Version)[1]', 'uniqueidentifier')
	from 
		@input.nodes('/BulkOperationShardMappingsLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @operationId is null or @stepsCount is null or @shardMapId is null or @shardId is null or @shardVersion is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	if exists (
		select 
			ShardId
		from
			__ShardManagement.ShardsLocal
		where
			ShardMapId = @shardMapId and ShardId = @shardId and Version = @shardVersion and LastOperationId = @operationId)
		goto Success_Exit;

	update __ShardManagement.ShardsLocal
	set
		Version = @shardVersion,
		LastOperationId = @operationId
	where
		ShardMapId = @shardMapId and ShardId = @shardId

	declare	@currentStep xml,
			@stepIndex int = 1,
			@stepType int,
			@stepMappingId uniqueidentifier

	while (@stepIndex <= @stepsCount)
	begin
		select 
			@currentStep = x.query('(./Step[@Id = sql:variable("@stepIndex")])[1]') 
		from 
			@input.nodes('/BulkOperationShardMappingsLocal/Steps') as t(x)

		select
			@stepType = x.value('(@Kind)[1]', 'int'),
			@stepMappingId = x.value('(Mapping/Id)[1]', 'uniqueidentifier')
		from
			@currentStep.nodes('./Step') as t(x)
	
		if (@stepType is null or @stepMappingId is null)
			goto Error_MissingParameters;

		if (@stepType = 1)
		begin
			delete
				__ShardManagement.ShardMappingsLocal
			where
				ShardMapId = @shardMapId and MappingId = @stepMappingId
		end
		else
		if (@stepType = 3)
		begin
			declare @stepMinValue varbinary(128),
					@stepMaxValue varbinary(128),
					@stepMappingStatus int

			select 
				@stepMinValue = convert(varbinary(128), x.value('(Mapping/MinValue)[1]', 'varchar(258)'), 1),
				@stepMaxValue = convert(varbinary(128), x.value('(Mapping/MaxValue[@Null="0"])[1]', 'varchar(258)'), 1),
				@stepMappingStatus = x.value('(Mapping/Status)[1]', 'int')
			from
				@currentStep.nodes('./Step') as t(x)

			if (@stepMinValue is null or @stepMappingStatus is null)
				goto Error_MissingParameters;

			begin try
				insert into
					__ShardManagement.ShardMappingsLocal
					(MappingId, 
					 ShardId, 
					 ShardMapId, 
					 MinValue, 
					 MaxValue, 
					 Status,
					 LastOperationId)
				values
					(@stepMappingId, 
					 @shardId, 
					 @shardMapId, 
					 @stepMinValue, 
					 @stepMaxValue, 
					 @stepMappingStatus,
					 @operationId)
			end try
			begin catch
			if (@undo != 1)
			begin
				declare @errorMessage nvarchar(max) = error_message(),
					@errorNumber int = error_number(),
					@errorSeverity int = error_severity(),
					@errorState int = error_state(),
					@errorLine int = error_line(),
					@errorProcedure nvarchar(128) = isnull(error_procedure(), '-');
					
					select @errorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + @errorMessage
					raiserror (@errorMessage, @errorSeverity, 1, @errorNumber, @errorSeverity, @errorState, @errorProcedure, @errorLine);
					rollback transaction; -- To avoid extra error message in response.
					goto Error_UnexpectedError;
			end
			end catch

			set @stepMinValue = null
			set @stepMaxValue = null
			set @stepMappingStatus = null

		end

		set @stepType = null
		set @stepMappingId = null

		set @stepIndex = @stepIndex + 1
	end

	goto Success_Exit;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
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
ALTER AUTHORIZATION ON [__ShardManagement].[spBulkOperationShardMappingsLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spFindShardMappingByKeyLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int,
			@lsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@keyValue varbinary(128)

	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@keyValue = convert(varbinary(128), x.value('(Key/Value)[1]', 'varchar(258)'), 1)
	from 
		@input.nodes('/FindShardMappingByKeyLocal') as t(x)
	
	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @shardMapId is null or @keyValue is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	declare @mapType int

	select 
		@mapType = MapType
	from
		__ShardManagement.ShardMapsLocal
	where
		ShardMapId = @shardMapId

	if (@mapType is null)
		goto Error_ShardMapNotFound;

	if (@mapType = 1)
	begin	
		select
			3, m.MappingId, m.ShardMapId, m.MinValue, m.MaxValue, m.Status, m.LockOwnerId,  -- fields for SqlMapping
			s.ShardId, s.Version, s.ShardMapId, s.Protocol, s.ServerName, s.Port, s.DatabaseName, s.Status -- fields for SqlShard, ShardMapId is repeated here
		from
			__ShardManagement.ShardMappingsLocal m
		join 
			__ShardManagement.ShardsLocal s
		on 
			m.ShardId = s.ShardId
		where
			m.ShardMapId = @shardMapId and 
			m.MinValue = @keyValue
	end
	else
	begin
		select 
			3, m.MappingId, m.ShardMapId, m.MinValue, m.MaxValue, m.Status, m.LockOwnerId,  -- fields for SqlMapping
			s.ShardId, s.Version, s.ShardMapId, s.Protocol, s.ServerName, s.Port, s.DatabaseName, s.Status -- fields for SqlShard, ShardMapId is repeated here
		from 
			__ShardManagement.ShardMappingsLocal m 
		join 
			__ShardManagement.ShardsLocal s 
		on 
			m.ShardId = s.ShardId
		where
			m.ShardMapId = @shardMapId and 
			m.MinValue <= @keyValue and (m.MaxValue is null or m.MaxValue > @keyValue)
	end

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
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spFindShardMappingByKeyLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetAllShardMappingsLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int, 
			@lsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@shardId uniqueidentifier,
			@minValue varbinary(128),
			@maxValue varbinary(128)

	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@shardId = x.value('(Shard/Id)[1]', 'uniqueidentifier'),
		@minValue = convert(varbinary(128), x.value('(Range[@Null="0"]/MinValue)[1]', 'varchar(258)'), 1),
		@maxValue = convert(varbinary(128), x.value('(Range[@Null="0"]/MaxValue[@Null="0"])[1]', 'varchar(258)'), 1)
	from 
		@input.nodes('/GetAllShardMappingsLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @shardMapId is null or @shardId is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	declare @mapType int

	select 
		@mapType = MapType
	from
		__ShardManagement.ShardMapsLocal
	where
		ShardMapId = @shardMapId

	if (@mapType is null)
		goto Error_ShardMapNotFound;

	declare @minValueCalculated varbinary(128) = 0x,
			@maxValueCalculated varbinary(128) = null

	if (@minValue is not null)
		set @minValueCalculated = @minValue

	if (@maxValue is not null)
		set @maxValueCalculated = @maxValue

	if (@mapType = 1)
	begin	
		select 
			3, m.MappingId, m.ShardMapId, m.MinValue, m.MaxValue, m.Status, m.LockOwnerId,  -- fields for SqlMapping
			s.ShardId, s.Version, s.ShardMapId, s.Protocol, s.ServerName, s.Port, s.DatabaseName, s.Status -- fields for SqlShard, ShardMapId is repeated here
		from 
			__ShardManagement.ShardMappingsLocal m 
			join 
			__ShardManagement.ShardsLocal s 
			on 
				m.ShardId = s.ShardId
		where
			m.ShardMapId = @shardMapId and 
			m.ShardId = @shardId and 
			MinValue >= @minValueCalculated and 
			((@maxValueCalculated is null) or (MinValue < @maxValueCalculated))
		order by 
			m.MinValue
	end
	else
	begin
		select 
			3, m.MappingId, m.ShardMapId, m.MinValue, m.MaxValue, m.Status, m.LockOwnerId,  -- fields for SqlMapping
			s.ShardId, s.Version, s.ShardMapId, s.Protocol, s.ServerName, s.Port, s.DatabaseName, s.Status -- fields for SqlShard, ShardMapId is repeated here
		from 
			__ShardManagement.ShardMappingsLocal m 
			join 
			__ShardManagement.ShardsLocal s 
			on 
				m.ShardId = s.ShardId
		where
			m.ShardMapId = @shardMapId and 
			m.ShardId = @shardId and 
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

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetAllShardMappingsLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetAllShardsLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int,
			@lsmVersionMinorClient int

	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int')
	from 
		@input.nodes('/GetAllShardsLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	select 
		1, ShardMapId, Name, MapType, KeyType
	from 
		__ShardManagement.ShardMapsLocal

	select 
		2, ShardId, Version, ShardMapId, Protocol, ServerName, Port, DatabaseName, Status 
	from
		__ShardManagement.ShardsLocal

	goto Success_Exit;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Success_Exit:
	set @result = 1
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetAllShardsLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetStoreVersionLocalHelper]
as
begin
	select
		5, StoreVersionMajor, StoreVersionMinor
	from 
		__ShardManagement.ShardMapManagerLocal
end

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spGetStoreVersionLocalHelper] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spKillSessionsForShardMappingLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int,
			@lsmVersionMinorClient int,
			@patternForKill nvarchar(128)

	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@patternForKill = x.value('(Pattern)[1]', 'nvarchar(128)')
	from 
		@input.nodes('/KillSessionsForShardMappingLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @patternForKill is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	declare @tvKillCommands table (spid smallint primary key, commandForKill nvarchar(10))

	insert into 
		@tvKillCommands (spid, commandForKill) 
	values 
		(0, N'')

	insert into 
		@tvKillCommands(spid, commandForKill) 
		select 
			session_id, 'kill ' + convert(nvarchar(10), session_id)
		from 
			sys.dm_exec_sessions 
		where 
			session_id > 50 and program_name like '%' + @patternForKill + '%'

	declare @currentSpid int, 
			@currentCommandForKill nvarchar(10)

	declare @current_error int

	select top 1 
		@currentSpid = spid, 
		@currentCommandForKill = commandForKill 
	from 
		@tvKillCommands 
	order by 
		spid desc

	while (@currentSpid > 0)
	begin
		begin try
			exec (@currentCommandForKill)

			delete 
				@tvKillCommands 
			where 
				spid = @currentSpid

			select top 1 
				@currentSpid = spid, 
				@currentCommandForKill = commandForKill 
			from 
				@tvKillCommands 
			order by 
				spid desc
		end try
		begin catch
			if (error_number() <> 6106)
				goto Error_UnableToKillSessions;
		end catch
	end

	set @result = 1
	goto Exit_Procedure;
	
Error_UnableToKillSessions:
	set @result = 305
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spKillSessionsForShardMappingLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spRemoveShardLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int, 
			@lsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@shardMapId uniqueidentifier,
			@shardId uniqueidentifier

	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@shardId = x.value('(Shard/Id)[1]', 'uniqueidentifier')
	from 
		@input.nodes('/RemoveShardLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @operationId is null or @shardMapId is null or @shardId is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	delete from
		__ShardManagement.ShardsLocal 
	where
		ShardMapId = @shardMapId and ShardId = @shardId

	delete from
		__ShardManagement.ShardMapsLocal 
	where
		ShardMapId = @shardMapId

	set @result = 1
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spRemoveShardLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [__ShardManagement].[spUpdateShardLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int, 
			@lsmVersionMinorClient int,
			@operationId uniqueidentifier,
			@shardMapId uniqueidentifier,
			@shardId uniqueidentifier,
			@shardVersion uniqueidentifier,
			@protocol int,
			@serverName nvarchar(128),
			@port int,
			@databaseName nvarchar(128),
			@shardStatus int

	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@operationId = x.value('(@OperationId)[1]', 'uniqueidentifier'),
		@shardMapId = x.value('(ShardMap/Id)[1]', 'uniqueidentifier'),
		@shardId = x.value('(Shard/Id)[1]', 'uniqueidentifier'),
		@shardVersion = x.value('(Shard/Version)[1]', 'uniqueidentifier'),
		@protocol = x.value('(Shard/Location/Protocol)[1]', 'int'),
		@serverName = x.value('(Shard/Location/ServerName)[1]', 'nvarchar(128)'),
		@port = x.value('(Shard/Location/Port)[1]', 'int'),
		@databaseName = x.value('(Shard/Location/DatabaseName)[1]', 'nvarchar(128)'),
		@shardStatus = x.value('(Shard/Status)[1]', 'int')
	from 
		@input.nodes('/UpdateShardLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @operationId is null or 
		@shardMapId is null or @shardId is null or @shardVersion is null or @shardStatus is null or
		@protocol is null or @serverName is null or @port is null or @databaseName is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	update 
		__ShardManagement.ShardsLocal
	set
		Version = @shardVersion,
		Status = @shardStatus,
		Protocol = @protocol,
		ServerName = @serverName,
		Port = @port,
		DatabaseName = @databaseName,
		LastOperationId = @operationId
	where
		ShardMapId = @shardMapId and ShardId = @shardId

	if (@@rowcount = 0)
		goto Error_ShardDoesNotExist;

	set @result = 1
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_ShardDoesNotExist:
	set @result = 202
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spUpdateShardLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spValidateShardLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int,
			@lsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@shardId uniqueidentifier,
			@shardVersion uniqueidentifier
	select 
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'), 
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMapId)[1]', 'uniqueidentifier'),
		@shardId = x.value('(ShardId)[1]', 'uniqueidentifier'),
		@shardVersion = x.value('(ShardVersion)[1]', 'uniqueidentifier')
	from 
		@input.nodes('/ValidateShardLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @shardMapId is null or @shardId is null or @shardVersion is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	declare @currentShardMapId uniqueidentifier
	
	select 
		@currentShardMapId = ShardMapId 
	from 
		__ShardManagement.ShardMapsLocal
	where 
		ShardMapId = @shardMapId

	if (@currentShardMapId is null)
		goto Error_ShardMapNotFound;

	declare @currentShardVersion uniqueidentifier

	select 
		@currentShardVersion = Version 
	from 
		__ShardManagement.ShardsLocal
	where 
		ShardMapId = @shardMapId and ShardId = @shardId

	if (@currentShardVersion is null)
		goto Error_ShardDoesNotExist;

	if (@currentShardVersion <> @shardVersion)
		goto Error_ShardVersionMismatch;

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_ShardDoesNotExist:
	set @result = 202
	goto Exit_Procedure;

Error_ShardVersionMismatch:
	set @result = 204
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spValidateShardLocal] TO  SCHEMA OWNER 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spValidateShardMappingLocal]
@input xml,
@result int output
as
begin
	declare @lsmVersionMajorClient int,
			@lsmVersionMinorClient int,
			@shardMapId uniqueidentifier,
			@mappingId uniqueidentifier

	select
		@lsmVersionMajorClient = x.value('(LsmVersion/MajorVersion)[1]', 'int'),
		@lsmVersionMinorClient = x.value('(LsmVersion/MinorVersion)[1]', 'int'),
		@shardMapId = x.value('(ShardMapId)[1]', 'uniqueidentifier'),
		@mappingId = x.value('(MappingId)[1]', 'uniqueidentifier')
	from
		@input.nodes('/ValidateShardMappingLocal') as t(x)

	if (@lsmVersionMajorClient is null or @lsmVersionMinorClient is null or @shardMapId is null or @mappingId is null)
		goto Error_MissingParameters;

	if (@lsmVersionMajorClient <> __ShardManagement.fnGetStoreVersionMajorLocal())
		goto Error_LSMVersionMismatch;

	declare @currentShardMapId uniqueidentifier
	
	select 
		@currentShardMapId = ShardMapId 
	from 
		__ShardManagement.ShardMapsLocal
	where 
		ShardMapId = @shardMapId

	if (@currentShardMapId is null)
		goto Error_ShardMapNotFound;

	declare @m_status_current int

	select 
		@m_status_current = Status
	from
		__ShardManagement.ShardMappingsLocal
	where
		ShardMapId = @shardMapId and MappingId = @mappingId
			
	if (@m_status_current is null)
		goto Error_MappingDoesNotExist;

	if (@m_status_current <> 1)
		goto Error_MappingIsOffline;

	set @result = 1
	goto Exit_Procedure;

Error_ShardMapNotFound:
	set @result = 102
	goto Exit_Procedure;

Error_MappingDoesNotExist:
	set @result = 301
	goto Exit_Procedure;

Error_MappingIsOffline:
	set @result = 309
	goto Exit_Procedure;

Error_MissingParameters:
	set @result = 50
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Error_LSMVersionMismatch:
	set @result = 51
	exec __ShardManagement.spGetStoreVersionLocalHelper
	goto Exit_Procedure;

Exit_Procedure:
end	

GO
ALTER AUTHORIZATION ON [__ShardManagement].[spValidateShardMappingLocal] TO  SCHEMA OWNER 
GO
