class profile::base {
  class { 'ntp':
    servers    => ["ntp.esl.cisco.com"],
  }
  
  apt::ppa { 'cloud-archive:liberty': }
  
}