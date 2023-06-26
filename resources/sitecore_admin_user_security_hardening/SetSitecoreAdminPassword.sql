:SETVAR SitecoreAdminUserName PlaceHolderForSitecoreAdminUserName
:SETVAR SitecoreAdminUserPassword PlaceHolderForSitecoreAdminUserPassword

SET NOCOUNT ON;

DECLARE @ApplicationName nvarchar(256) = 'sitecore';
DECLARE @UserName nvarchar(256) = '$(SitecoreAdminUserName)';
DECLARE @Password nvarchar(128) = '$(SitecoreAdminUserPassword)';
DECLARE @HashAlgorithm nvarchar(10) = 'SHA2_512';
DECLARE @PasswordFormat int = 1; -- Hashed
DECLARE @CurrentTimeUtc datetime = SYSUTCDATETIME();
DECLARE @Salt varbinary(16) = 0x;
DECLARE @HashedPassword varbinary(512);
DECLARE @EncodedHash nvarchar(128);
DECLARE @EncodedSalt nvarchar(128);

-- Generate random salt
WHILE LEN(@Salt) < 16
BEGIN
	SET @Salt = (@Salt + CAST(CAST(FLOOR(RAND() * 256) AS tinyint) AS binary(1)))
END;

-- Hash password
SET @HashedPassword = HASHBYTES(@HashAlgorithm, @Salt + CAST(@Password AS varbinary(128)));

-- Convert hash and salt to BASE64
SELECT @EncodedHash = CAST(N'' AS xml).value('xs:base64Binary(xs:hexBinary(sql:column("bin")))', 'varchar(max)') FROM (SELECT @HashedPassword AS [bin] ) T;
SELECT @EncodedSalt = CAST(N'' AS xml).value('xs:base64Binary(xs:hexBinary(sql:column("bin")))', 'varchar(max)') FROM (SELECT @Salt AS [bin] ) T;

PRINT N'Updating password for Sitecore Administrator user [$(SitecoreAdminUserName)]...';
EXECUTE [dbo].[aspnet_Membership_SetPassword] @ApplicationName, @UserName, @EncodedHash, @EncodedSalt, @CurrentTimeUtc, @PasswordFormat;
GO

PRINT N'Resetting LockedOut status for Sitecore Administrator user [$(SitecoreAdminUserName)]...';
DECLARE @UserName nvarchar(256) = '$(SitecoreAdminUserName)';
UPDATE  [dbo].[aspnet_Membership]
SET     IsLockedOut = 0,
        FailedPasswordAttemptCount = 0
WHERE   UserId IN (SELECT UserId FROM aspnet_Users WHERE UserName = @UserName);
GO
