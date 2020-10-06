module Container
  module Backup
    class Mysql < Directories

      def backup
        #  eval "ssh ru-dm.aegean.gr 'mysqldump --force --routines -h localhost -u root -p$mysql_root_password ele > ele_dev.sql'"
        #eval "ssh ru-vm2.aegean.gr 'scp ru-dm.ru.aegean.gr:~/ele_dev.sql /tmp/ele_dev.sql'"
        mkdir_p(backup_path)
        sh "docker exec #{container} sh -c 'mysqldump --force --routines -h localhost -u root -p#{params['password']} #{params['db']} > /#{backup_path}/#{params['db']}.sql'"
      end
      def restore
        # user == db
        sh "docker exec #{container} sh -c 'echo \"DROP USER \'#{params['db']}\'@'%\' ;DROP DATABASE #{params['db']};\" | mysql -u root -p#{params['password']}'"
        sh "docker exec #{container} sh -c 'echo \"CREATE DATABASE #{params['db']};CREATE USER \'#{params['user']}\'@\'%\' IDENTIFIED BY \'#{params['password']}\';GRANT ALL PRIVILEGES ON *.* TO \'#{params['user']}\'@\'%\';FLUSH PRIVILEGES;\" | mysql -u root -p#{params['password']}'"
        sh "docker exec #{container} sh -c 'mysql -u root -p#{params['password']} #{params['db']} < /#{backup_path}/#{params['db']}.sql'"
      end
    end

    class Mssql < Step
      # - "backup={volumes: [drupal_mysql_data],databases: [mysql: {db: ${MYSQL_DATABASE},password: ${MYSQL_ROOT_PASSWORD},user: root}]}"
      # - "backup.1={databases: [mysql: {db: ${MYSQL_DATABASE}2,password: ${MYSQL_ROOT_PASSWORD},user: root}]}"

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
        #docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P %SA_PASSWORD% -d master -i /root/mssql/map_logins.sql
        #start
      end

    end

    class Mongo < Step
      # https://docs.mongodb.com/database-tools/mongodump/#bin.mongodump
      # https://docs.mongodb.com/database-tools/mongorestore/#bin.mongorestore
      #
      #       - "backup={volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}"
      #
      def backup
        #  mongodump --host="mongodb0.example.com" --port=27017 [additional options]
        stop
        sh "docker run -it --rm --volumes-from #{container} #{image} bash -c 'mongodump -v --host=#{params['host'] || 'localhost'} --port=#{params['port'] || 27017} --out=/#{backup_path}'"
        start
      end
      def restore
        # mongorestore --username joe --password secret1 --host=mongodb0.example.com --port=27017
        # docker run -it --rm --link mongo:mongo -v /tmp/mongodump:/tmp mongo bash -c 'mongorestore -v --host $MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT /tmp'
        stop
        sh "docker run -it --rm --volumes-from #{container} #{image} bash -c 'mongorestore -v --host=#{params['host'] || 'localhost'} --port=#{params['port'] || 27017} /#{backup_path}'"
        start
      end
    end

    class Chronograf < Step
      # https://www.influxdata.com/blog/chronograf-dashboard-definitions/
      #
      #       - "backup={volumes: [chronograf_data],databases: [chronograf]}"
      #
      def get_dashboard_ids(save=true)
        sh "docker exec  #{container} sh -c 'curl -i X GET http://127.0.0.1:8888/chronograf/v1/dashboards > /#{backup_path}/dashboards.json'" if save
        JSON.parse(File.open("/#{backup_path}/dashboards.json"))['dashboards'].map{|d| d['id']}
      end

      def backup
        get_dashboard_ids(false).each do |i|
          sh "docker exec #{container} sh -c 'curl -i -X GET http://127.0.0.1:8888/chronograf/v1/dashboards/#{i} > /#{backup_path}/i.json'"
        end
      end

      def restore
        get_dashboard_ids.each do |i|
          sh "docker exec #{container} sh -c 'curl -i -X POST -H \"Content-Type: application/json\" http://127.0.0.1:8888/chronograf/v1/dashboards -d @/#{i}.json'"
        end
      end

    end

    class Influxdb < Step
      # https://www.influxdata.com/blog/new-features-in-open-source-backup-and-restore/
      #
      #     - "backup={volumes: [influxdb_data],databases: [influxdb: {user: ${INFLUXDB_ADMIN_USER},password: ${INFLUXDB_ADMIN_PASSWORD}}]}"
      #
      #
      def backup
        # influxd backup -portable [options] <path-to-backup>
        #
        # Backup Options
        #
        # -host <host:port> – The host to connect to and perform a snapshot of. Defaults to 127.0.0.1:8088.
        #     -database <name> – The database to backup. Optional. If not given, all databases are backed up.
        #     -retention <name> – The retention policy to backup. Optional.
        #     -shard <id> – The shard id to backup. Optional. If specified, -retention is required.
        #     -since <2015-12-24T08:12:13Z> – Do a file-level backup since the given time. The time needs to be in the RFC3339 format. Optional.
        #     -start <2015-12-24T08:12:23Z> – All points earlier than this timestamp will be excluded from the export. Not compatible with -since.
        #     -end <2015-12-24T08:12:23Z> – All points later than this time stamp will be excluded from the export. Not compatible with -since.
        #     -portable – Generate backup files in the format used for InfluxDB Enterprise.

        sh "docker exec #{container} sh -c 'influxd backup -protable /#{backup_path}'"

      end
      def restore
        # influxd restore -portable [options] <path-to-backup>
        # Regardless of whether you have existing backup automation that supports the legacy format, or you are a new user, you may wish to test the new online feature for legacy to gain the advantages described above. It is activated by using either the -portable or -online flags. The flags indicate that the input is in either the new portable backup format (which is the same format that Enterprise InfluxDB uses), or the legacy backup format, respectively. It has the following options:
        #     -host <host:port> – The host to connect to and perform a snapshot of. Defaults to 127.0.0.1:8088.
        #     -db <name> – Identifies the database from the backup that will be restored.
        #     -newdb <name> – The name of the database into which the archived data will be imported on the target system. If not given, then the value of -db is used. The new database name must be unique to the target system.
        #     -rp <name> – Identifies the retention policy from the backup that will be restored. Requires that -db is set.
        #     -newrp <name> – The name of the retention policy that will be created on the target system. Requires that -rp is set. If not given, the value of -rp is used.
        #     -shard <id> – Optional. If given, -db and -rp are required. Will restore the single shard’s data.

        sh "docker exec #{container} sh -c 'influxd restore -protable /#{backup_path}'"

      end
    end

  end
end