class profile::base (
  String $os_username,
  String $os_password, #Not plain text!
  String $ssh_key, #RSA public key
) {
  # This is a hack - it doesn't seem to be possible to get a literal '$' through PE's class parameter GUI:
  $realpw = regsubst($os_password, 'DOLLAR', '$', 'G')
  
  class { 'ntp':
    servers    => ["ntp.esl.cisco.com"],
  }
  
  case $::osfamily {
    'Debian': {
      class {'apt': }
      apt::ppa { 'cloud-archive:liberty': }
      
      $groups = 'sudo'
    }
    'RedHat': {
      package {'centos-release-openstack-liberty':
        ensure    => present,
      }
      
      class { 'selinux':
        mode    => 'permissive',
      }
      
      $groups = 'wheel'
    }
  }
  
  
  group {$os_username :
    ensure  => present,
  }
  
  user {$os_username :
    ensure   => present,
    shell    => '/bin/bash',
    groups   => $groups,
    gid      => $os_username,
    password => $realpw,
  }
  
  file {"/home/$os_username" :
    ensure    => directory,
    owner     => $os_username,
    group     => $os_username,
    mode      => '0750',
    require   => [ User[$os_username], Group[$os_username] ]
  }
  
  ssh_authorized_key { $os_username :
    user   => $os_username,
    key    => $ssh_key,
    type   => 'ssh-rsa'
  }
  
  if $::osfamily == 'Debian' {
    package { 'lldpd': 
      ensure    => present,
    }
  }
  
}