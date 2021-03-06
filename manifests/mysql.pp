class profile::mysql (
  String $root_password = 'C1sco123',
) {
  class { 'mysql::server': 
    root_password     => $root_password,
    override_options  => {
      'mysqld'  => {
        'max_connections' => '1000',
      }
    }
  }
}