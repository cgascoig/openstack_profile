class profile::base {
  class { 'ntp':
    servers    => ["ntp.esl.cisco.com"],
  }
  class {'apt': }
  apt::ppa { 'cloud-archive:liberty': }
  
  group {'cgascoig':
    ensure  => present,
  }
  
  user {'cgascoig':
    ensure   => present,
    shell    => '/bin/bash',
    groups   => 'sudo',
    gid      => 'cgascoig',
    password => '***REMOVED***'
  }
  
  file {'/home/cgascoig':
    ensure    => directory,
    owner     => "cgascoig",
    group     => "cgascoig",
    mode      => '0750',
    require   => [ User['cgascoig'], Group['cgascoig'] ]
  }
  
  ssh_authorized_key { 'cgascoig':
    user   => 'cgascoig',
    key    => '***REMOVED***',
    type   => 'ssh-rsa'
  }
  
  package { 'lldpd': 
    ensure    => present,
  }
  
}