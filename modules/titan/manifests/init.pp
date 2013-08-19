class titan( $version, $titanetc = '/etc/titan' ) {

      require titan::repo

	$titan_cassandra_dir = '/var/lib/titan/cassandra'

	$titan_config = {
		'storage.backend' => 'embeddedcassandra',
		'storage.cassandra-config-dir' => 'cassandra.yaml',
		'storage.index.search.backend' => 'elasticsearch',
		'storage.index.search.directory' => '/var/lib/titan/es',
		'storage.index.search.client-only' => 'false',
		'storage.index.search.local-mode' => 'true',
	}

	file { 'config.properties':
		path => "${titanetc}/config.properties",
		ensure => file,
		content => template("${module_name}/titan.properties.erb"),
		require => Package['titan-cassandra'],
	}

	file { 'cassandra.yaml':
		path => "${titanetc}/cassandra.yaml",
		ensure => file,
		content => template("${module_name}/cassandra.yaml.erb"),
		require => Package['titan-cassandra'],
	}

	package { 'titan-cassandra':
		ensure => "$version",
	}

	package { 'titan-es':
		ensure => "$version",
	}

	service { 'titan':
		ensure => running,
		enable => true,
		require => [ File['config.properties'], File['cassandra.yaml'], Package['titan-cassandra'], Package['titan-es'] ],
	}
}
