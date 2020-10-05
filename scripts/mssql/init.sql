--RESTORE FILELISTONLY FROM  DISK = 'G:\MSSQL\Backup\#{db_name}.bak' ;
--"BACKUP LOG [demodb] TO  DISK = N'var/opt/mssql/data/demodb_LogBackup_2016-11-14_18-09-53.bak' WITH NOFORMAT, NOINIT,  NAME = N'demodb_LogBackup_2016-11-14_18-09-53', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5"
-- for #{db_name}Dev


-- differential
-- docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master
-- RESTORE DATABASE [#{db_name}Dev] FROM  DISK = N'/root/backups/1.bak' WITH  FILE = 1, NORECOVERY, REPLACE;
-- RESTORE DATABASE [#{db_name}Dev] FROM  DISK = N'/root/backups/2.bak' WITH  FILE = 1, RECOVERY;

IF ( EXISTs (SELECT name FROM master.dbo.sysdatabases WHERE name = '$(DB_NAME)2Dev'))
 drop DATABASE $(DB_NAME)2Dev
 create DATABASE $(DB_NAME)2Dev

ALTER DATABASE $(DB_NAME)2Dev
SET SINGLE_USER WITH ROLLBACK AFTER 5 --this will give your current connections 60 seconds to complete
go
RESTORE DATABASE [$(DB_NAME)2Dev] FROM  DISK = N'/root/backups/$(DB_NAME)2Dev.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5;
GO
ALTER DATABASE $(DB_NAME)2Dev SET MULTI_USER
GO
USE master ;
ALTER DATABASE $(DB_NAME)2Dev SET RECOVERY SIMPLE;
GO
DBCC SHRINKDATABASE ($(DB_NAME)2Dev, TRUNCATEONLY);
--GO
--DBCC SHRINKDATABASE ($(DB_NAME)2Dev, 10);
GO
