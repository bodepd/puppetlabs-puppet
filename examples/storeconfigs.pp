Apt::Source['puppet'] -> Package<| |>

apt::source { 'puppet':
  location => 'http://apt.puppetlabs.com/ubuntu',
  release  => 'natty',
  key      => '4BD6EC30',
}

class { 'mysql::server':
  config_hash => {'bind_address' => '127.0.0.1'}
}
class { 'mysql::ruby': }
package { 'activerecord':
  ensure   => '2.3.5',
  provider => 'gem',
}

if($operatingsystem == 'Ubuntu') {
  $master_package = 'puppetmaster-passenger'
} else {
  $master_package = 'puppet'
}

class { 'puppet::master':
  storeconfigs            => true,
  storeconfigs_dbuser     => 'dan',
  storeconfigs_dbpassword => 'dans_password',
  storeconfigs_dbadapter  => 'mysql',
  storeconfigs_dbserver   => 'localhost',
  storeconfigs_dbsocket   => '/var/run/mysqld/mysqld.sock',
  version                 => installed,
  puppet_master_package   => $master_package,
  puppet_master_service   => 'apache2',
  autosign                => 'true',
  certname                => $clientcert,
}
