PRINT "Backup #{db_name} db"
go
BACKUP DATABASE #{db_name} TO DISK = 'G:\MSSQL\Backup\#{db_name}.bak' WITH FORMAT,COMPRESSION;
go
