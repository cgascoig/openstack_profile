class profile::neutron_compute (
  String $rabbit_host,
  String $rabbit_username = 'openstack',
  String $rabbit_password,
) {
  
  class { 'neutron':
    verbose                 => true,
    debug                   => true,
    
    allow_overlapping_ips   => true,
    core_plugin             => 'ml2',
    service_plugins         => [ 'router' ],
    
    rabbit_host             => $rabbit_host,
    rabbit_user             => $rabbit_username,
    rabbit_password         => $rabbit_password,
  }
  
  class { 'neutron::plugins::ml2':
    type_drivers          => [ 'vxlan' ],
    tenant_network_types  => [ 'vxlan' ],
    vxlan_group           => '239.1.1.1',
    mechanism_drivers     => [ 'openvswitch' ],
    vni_ranges            => '10000:10500',
  }
  
  class { 'neutron::agents::ml2::ovs':
    local_ip          => $::ipaddress,
    enable_tunneling  => true,
    tunnel_types      => [ 'vxlan' ],
  }
}