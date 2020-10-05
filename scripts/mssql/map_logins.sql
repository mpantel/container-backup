
  use $(DB_NAME)2Dev
  go
  IF NOT EXISTS (SELECT name FROM master.sys.server_principals WHERE name = '#{user_name}')
    create login #{user_name} with password ='$(SA_PASSWORD)',DEFAULT_database = [$(DB_NAME)2Dev]

  SET QUOTED_IDENTIFIER ON
  go

  EXEC sp_change_users_login 'Auto_Fix', '#{username}'


go