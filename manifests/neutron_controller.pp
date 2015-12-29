class profile::neutron_controller (
  String $db_username = 'neutron',
  String $db_password,
  String $db_host = '127.0.0.1',
  String $db_name = 'neutron',
  String $rabbit_host = '127.0.0.1',
  String $rabbit_username = 'openstack',
  String $rabbit_password,
  String $keystone_tenant = 'services',
  String $keystone_user = 'neutron',
  String $keystone_password,
  
  String $neutron_metadata_proxy_shared_secret,
  String $nova_keystone_tenant = 'services',
  String $nova_keystone_user = 'neutron',
  String $nova_keystone_password,
) {
  
  class { 'neutron::db::mysql':
    user      => $db_username,
    password  => $db_password,
    dbname    => $db_name,
    host      => $db_host,
    allowed_hosts => '%',
  }
  
  class { 'neutron::keystone::auth':
    email               => "$keystone_user@example.com",
    auth_name           => $keystone_user,
    password            => $keystone_password,
    tenant              => $keystone_tenant,
    
    public_url          => "http://${::ipaddress}:8774/v2/%(tenant_id)s",
    admin_url           => "http://${::ipaddress}:8774/v2/%(tenant_id)s",
    internal_url        => "http://${::ipaddress}:8774/v2/%(tenant_id)s",
  }
  
  class { 'neutron':
    verbose                 => true,
    debug                   => true,
    rabbit_user           => $rabbit_username,
    rabbit_password         => $rabbit_password,
    rabbit_host             => $rabbit_host,
    
    allow_overlapping_ips   => true,
    service_plugins         => [ 'router' ],
    core_plugin             => 'ml2',
  }
  
  class { 'neutron::server':
    auth_uri          => "http://${::ipaddress}:5000/v2.0",
    identity_uri      => "http://${::ipaddress}:35357",
    auth_user         => $keystone_user,
    auth_password     => $keystone_password,
    auth_tenant       => $keystone_tenant,
    
    database_connection     => "mysql://$db_username:$db_password@$db_host/$db_name",
  }
  
  class { 'neutron::server::notifications':
    tenant_name      => $nova_keystone_tenant,
    username         => $nova_keystone_user,
    password         => $nova_keystone_password,
    nova_url         => "http://${::ipaddress}:8774/v2",
    auth_url         => "http://${::ipaddress}:35357",
  }
  
  class { 'neutron::agents::dhcp': }
  class { 'neutron::agents::l3': }
  
  class { 'neutron::agents::metadata': 
    shared_secret     => $neutron_metadata_proxy_shared_secret,
    auth_username     => $keystone_user,
    auth_password     => $keystone_password,
    auth_tenant       => $keystone_tenant,
    auth_url          => "http://${::ipaddress}:35357/v2.0",
    metadata_ip       => $::ipaddress,
  }
  
  class {'neutron::agents::ml2::ovs': 
    local_ip          => $::ipaddress,
    enable_tunneling  => true,
    tunnel_types      => [ 'vxlan' ],
  }
  
  class { 'neutron::plugins::ml2':
    type_drivers          => [ 'vxlan' ],
    tenant_network_types  => [ 'vxlan' ],
    vxlan_group           => '239.1.1.1',
    mechanism_drivers     => [ 'openvswitch' ],
    vni_ranges            => '10000:10500',
  }
}