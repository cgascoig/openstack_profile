class profile::nova_controller (
  String $db_username = 'nova',
  String $db_password,
  String $db_host = '127.0.0.1',
  String $db_name = 'nova',
  String $rabbit_host = '127.0.0.1',
  String $rabbit_username = 'openstack',
  String $rabbit_password,
  String $keystone_tenant = 'services',
  String $keystone_user = 'nova',
  String $keystone_password,
  
  String $neutron_metadata_proxy_shared_secret,
  String $neutron_keystone_tenant = 'services',
  String $neutron_keystone_user = 'neutron',
  String $neutron_keystone_password,
){
  
  class { 'nova::db::mysql':
    user      => $db_username,
    password  => $db_password,
    dbname    => $db_name,
    host      => $db_host,
    allowed_hosts => '%',
  }
  
  class { 'nova::keystone::auth':
    email               => "$keystone_user@example.com",
    auth_name           => $keystone_user,
    password            => $keystone_password,
    tenant              => $keystone_tenant,
    
    public_url          => "http://${::ipaddress}:8774/v2/%(tenant_id)s",
    admin_url           => "http://${::ipaddress}:8774/v2/%(tenant_id)s",
    internal_url        => "http://${::ipaddress}:8774/v2/%(tenant_id)s",
    
    public_url_v3       => "http://${::ipaddress}:8774/v3",
    admin_url_v3        => "http://${::ipaddress}:8774/v3",
    internal_url_v3     => "http://${::ipaddress}:8774/v3",
    
    ec2_public_url      => "http://${::ipaddress}:8773/services/Cloud",
    ec2_internal_url    => "http://${::ipaddress}:8773/services/Cloud",
    ec2_admin_url_url   => "http://${::ipaddress}:8773/services/Admin",
  }
  
  class { 'nova':
    verbose         => true,
    debug           => true,
    rabbit_userid   => $rabbit_username,
    rabbit_password => $rabbit_password,
    rabbit_host     => $rabbit_host,
    database_connection => "mysql://$db_username:$db_password@$db_host/$db_name",
  }
  
  class { 'nova::api':
    auth_uri          => "http://${::ipaddress}:5000/v2.0",
    identity_uri      => "http://${::ipaddress}:35357",
    admin_user        => $keystone_user,
    admin_password    => $keystone_password,
    admin_tenant_name => $keystone_tenant,
    neutron_metadata_proxy_shared_secret    => $neutron_metadata_proxy_shared_secret,
    
  }
  
  class { 'nova::network::neutron':
    neutron_url               => "http://${::ipaddress}:9696",
    neutron_admin_auth_url    => "http://${::ipaddress}:35357/v2.0",
    
    neutron_admin_tenant_name => $neutron_keystone_tenant,
    neutron_admin_username    => $neutron_keystone_user,
    neutron_admin_password    => $neutron_keystone_password,
  }
  
  class { 'nova::scheduler': }
  class { 'nova::conductor': }
  class { 'nova::consoleauth': }
  class { 'nova::cert': }
  class { 'nova::objectstore': }
  
  class { 'nova::vncproxy': }
}