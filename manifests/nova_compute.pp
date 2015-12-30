class profile::nova_compute (
  String $db_username = 'nova',
  String $db_password,
  String $db_host,
  String $db_name = 'nova',
  String $rabbit_host,
  String $rabbit_username = 'openstack',
  String $rabbit_password,
  
  String $glance_host,
  String $keystone_host,
  String $vncproxy_host,
  
  # String $keystone_tenant = 'services',
  # String $keystone_user = 'nova',
  # String $keystone_password,
  #
  # String $neutron_metadata_proxy_shared_secret,
  String $neutron_keystone_tenant = 'services',
  String $neutron_keystone_user = 'neutron',
  String $neutron_keystone_password,
){
  
  class { 'nova':
    verbose                 => true,
    debug                   => true,
    
    database_connection     => "mysql://$db_username:$db_password@$db_host/$db_name",
    rabbit_host             => $rabbit_host,
    rabbit_userid           => $rabbit_username,
    rabbit_password         => $rabbit_password,
    
    glance_api_servers      => "$glance_host:9292",
  }
  
  class { 'nova::network::neutron':
    neutron_admin_auth_url        => "http://$keystone_host:35357/v2.0",
    neutron_admin_username        => $neutron_keystone_user,
    neutron_admin_password        => $neutron_keystone_password,
    neutron_admin_tenant_name     => $neutron_keystone_tenant,
    
    neutron_url                   => "http://$keystone_host:9696",
  }
  
  class { 'nova::compute':
    vncserver_proxyclient_address   => $::ipaddress,
    vncproxy_host                   => $vncproxy_host,
  }
  
  class { 'nova::compute::libvirt':
    vncserver_listen      => "0.0.0.0",
  }
}