class profile::base {
  class { 'ntp':
    servers    => ["ntp.esl.cisco.com"],
  }
  
  class { 'apt':
    # apt_update_frequency   => "daily",
    ppas                   => ["cloud-archive:liberty"],
  }
  
}