class profile::keystone (
  String $admin_token,
  String $db_username = 'keystone',
  String $db_password,
  String $db_host = '127.0.0.1',
  String $db_name = 'keystone',
  String $rabbit_host = '127.0.0.1',
  String $rabbit_username = 'openstack',
  String $rabbit_password,
  String $admin_user_password,
  String $admin_user_email,
  
  
){
  class { 'keystone::db::mysql':
    user          => $db_username,
    password      => $db_password,
    host          => $db_host,
    dbname        => $db_name,
    allowed_hosts => '%',
  }
  
  class { 'keystone':
    verbose             => true,
    debug               => true,
    admin_token         => $admin_token,
    database_connection => "mysql://$db_username:$db_password@$db_host/$db_name",
    rabbit_host         => $rabbit_host,
    rabbit_userid       => $rabbit_username,
    rabbit_password     => $rabbit_password,
  }
  
  class { 'keystone::endpoint':
    public_url      => "http://10.67.28.164:5000",
    admin_url       => "http://10.67.28.164:35357",
    internal_url    => "http://10.67.28.164:5000",
    region          => "regionOne",
  }
  
  keystone_tenant {'admin':
    ensure    => present,
    enabled   => true,
  }
  
  keystone_tenant {'services':
    ensure    => present,
    enabled   => true,
  }
  
  keystone_tenant {'demo':
    ensure    => present,
    enabled   => true,
  }
  
  keystone_user { 'admin':
    ensure    => present,
    enabled   => true,
    password  => $admin_user_password,
    email     => $admin_user_email,
  }
  
  keystone_role {'admin':
    ensure  => present,
  }
  
  keystone_user_role {'admin@admin':
    ensure    => present,
    user      => 'admin',
    project   => 'admin',
    roles     => ['admin'],
  }
}