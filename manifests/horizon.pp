class profile::horizon (

) {

  class { 'memcached':
    
  }

  class { 'horizon':
    secret_key      => '12345',
    cache_server_ip => '127.0.0.1',
  }
}