class profile::glance (
  String $db_username = 'glance',
  String $db_password,
  String $db_host = '127.0.0.1',
  String $db_name = 'glance',
  String $rabbit_host = '127.0.0.1',
  String $rabbit_username = 'openstack',
  String $rabbit_password,
  String $keystone_tenant = 'services',
  String $keystone_user = 'glance',
  String $keystone_password,
) {
  class { 'glance::db::mysql':
    user      => $db_username,
    password  => $db_password,
    dbname    => $db_name,
    host      => $db_host,
    allowed_hosts => '%',
  }
  
  class { 'glance::api':
    verbose             => true,
    keystone_tenant     => $keystone_tenant,
    keystone_user       => $keystone_user,
    keystone_password   => $keystone_password,
    database_connection => "mysql://$db_username:$db_password@$db_host/$db_name",
  }
  
  class { 'glance::registry':
    verbose             => true,
    keystone_tenant     => $keystone_tenant,
    keystone_user       => $keystone_user,
    keystone_password   => $keystone_password,
    database_connection => "mysql://$db_username:$db_password@$db_host/$db_name",
  }
  
  class { 'glance::backend::file':
    
  }
  
  class { 'glance::keystone::auth':
    email         => "$keystone_user@example.com",
    auth_name     => $keystone_user,
    password      => $keystone_password,
    tenant        => $keystone_tenant,
    public_url    => "http://${::ipaddress}:9292",
    admin_url     => "http://${::ipaddress}:9292",
    internal_url  => "http://${::ipaddress}:9292",
  }
  
  class { 'glance::notify::rabbitmq':
    rabbit_host     => $rabbit_host,
    rabbit_userid   => $rabbit_username,
    rabbit_password => $rabbit_password,
  }
}