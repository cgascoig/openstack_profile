class profile::base {
  class { 'ntp':
    servers    => ["ntp.esl.cisco.com"],
  }
  class {'apt': }
  apt::ppa { 'cloud-archive:liberty': }
  
}