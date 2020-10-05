
use master;
go
print "Restore dev db"
go
IF ( EXISTs (SELECT name FROM master.dbo.sysdatabases WHERE name = '$(DB_NAME)2Dev'))
 drop DATABASE $(DB_NAME)2Dev
go
create DATABASE $(DB_NAME)2Dev
go
ALTER DATABASE $(DB_NAME)2Dev
SET SINGLE_USER WITH
ROLLBACK AFTER 5 --this will give your current connections 60 seconds to complete
go
RESTORE DATABASE $(DB_NAME)2Dev FROM  DISK = '/root/backups/$(DB_NAME)2Dev.bak'
WITH  REPLACE;
GO
ALTER DATABASE $(DB_NAME)2Dev SET MULTI_USER
GO
