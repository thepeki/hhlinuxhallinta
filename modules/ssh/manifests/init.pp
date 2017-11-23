class ssh {
	package { 'openssh-server':
		ensure => 'installed',
		allowcdrom => true,
	}
	service { 'ssh':
		ensure => 'running',
		enable => true,
	}
}
