# Authors
# -------
#
# Damien MALINEAU <damien.malineau@ynov.com>
#
# Copyright
# ---------
#
# Copyright 2017 Damien MALINEAU.
#

class cust_mysql (
  String $mysqlPassword = 'azertyuiop',
  String $mysqlId = '1',
  String $mysqlAutoIncrementOffset = '1',
  String $mysqlMasterHost = 'localhost',
) {

  class { 'mysql::server':
    restart => true,
    root_password => $mysqlPassword,
    override_options => { 
      mysqld => { 
        bind_address => '0.0.0.0',
        max_connections => '1024',
        server-id => $mysqlId,
        binlog-format => 'mixed',
        log-bin => '/var/log/mysql/mysql-bin.log',
        datadir => '/var/lib/mysql',
        innodb_flush_log_at_trx_commit => '1',
        sync_binlog => '1',
        auto-increment-increment => '2',
        auto-increment-offset => $mysqlAutoIncrementOffset,
      },
    }
  }
  
  mysql_user { 'root@%':
    ensure => 'present',
    password_hash => mysql_password($mysqlPassword),
  }

  mysql_grant { 'root@%/*.*':
    ensure => 'present',
    privileges => ['ALL'],
    table => '*.*',
    user => 'root@%',
  }

#  exec { "mysql -uroot -p$mysqlPassword -e \"STOP SLAVE\"":
#    path   => '/usr/bin',
#  }

#  exec { "mysql -uroot -p$mysqlPassword -e \"CHANGE MASTER TO MASTER_HOST=\'$mysqlMasterHost\', MASTER_USER=\'root\', MASTER_PASSWORD=\'$mysqlPassword\', MASTER_LOG_FILE=\'mysql-bin.000001\', MASTER_LOG_POS=107\"":
#    path   => '/usr/bin',
#  }
}
