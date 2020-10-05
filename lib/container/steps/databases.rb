module Container
  module Backup

    class Mysql < Step
      def backup
        #  eval "ssh ru-dm.aegean.gr 'mysqldump --force --routines -h localhost -u root -p$mysql_root_password ele > ele_dev.sql'"
        #eval "ssh ru-vm2.aegean.gr 'scp ru-dm.ru.aegean.gr:~/ele_dev.sql /tmp/ele_dev.sql'"
        sh "docker exec --mount source=#{backup_path},target=/backup #{container} mysqldump --force --routines -h localhost -u root -p#{params[:password]} #{params[:db]} > /backup/#{params[:db]}.sql'"
      end
      def restore
        sh "docker exec #{container} sh -c 'echo \"DROP USER \'#{params[:user]}\'@'%\' ;DROP DATABASE #{params[:db]};\" | mysql -u root -p#{params[:password]}'"
        sh "docker exec #{container} sh -c 'echo \"CREATE DATABASE #{params[:db]};CREATE USER \'#{params[:user]}\'@\'%\' IDENTIFIED BY \'#{params[:password]}\';GRANT ALL PRIVILEGES ON *.* TO \'params[:user]\'@\'%\';FLUSH PRIVILEGES;\" | mysql -u root -p#{params[:password]}'"
        sh "docker exec #{container} sh -c 'mysql -u root -p#{params[:password]} #{params[:db]} < /backup/#{params[:db]}.sql'"
      end
    end

    class Mssql < Step
      def backup
        raise "not yet implemented #{self.class.name} backup step"
        #  docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S ru-db.aegean.gr -U sa -P $mssql_root_password -d master -i /root/mssql/backup_mssql_dbs.sql
        #echo 'Press any key to copy backups to staging...'; #read -s -n1
        #docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S ru-db.aegean.gr -U sa -P $mssql_root_password -d master -i /root/mssql/copy_mssql_dbs_to_staging.sql

      end
      def restore
        raise "not yet implemented #{self.class.name} backup step"
        #stop
        #sh "docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P %SA_PASSWORD% -d master -i /root/mssql/init.sql"
        #start
      end

    end

    class Mongo < Step
      def backup

      end
      def restore

      end
    end

    class Chronograf < Step
      def backup

      end
      def restore

      end
    end

    class Influxdb < Step
      def backup

      end
      def restore

      end
    end

  end
end