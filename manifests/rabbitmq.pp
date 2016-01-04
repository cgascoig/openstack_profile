class profile::rabbitmq (
  String $username = 'openstack',
  String $password = 'C1sco123',
) {
  case ::$osfamily {
    'RedHat': {
      include 'erlang'
      class { 'erlang': epel_enable => true}
    }
  }
  
  include '::rabbitmq'
  
  rabbitmq_user { $username:
    admin    => false,
    password => $password,
  }
  
  rabbitmq_vhost { '/':
    ensure  => present
  }
  
  rabbitmq_user_permissions { 'openstack@/':
    configure_permission   => '.*',
    read_permission        => '.*',
    write_permission       => '.*',
  }
}