class myrasp {
      
      # globaalit parametrit
      Package { ensure => 'installed' }
      Service { 
          ensure => 'running',
          enable => true,
      }
      
      # paketit
      package { 'irssi': }
      package { 'screen': }
      package { 'git': }
      package { 'apache2': }
      package { 'mumble-server': }
      package { 'samba': }
      
      # filet
      file { '/etc/samba/smb.conf':
          content => template("myrasp/smb.conf"),
          require => Package["samba"],
          notify => Service["samba"],
          
      }
      
      # servicet
      service { 'apache2':
          require => Package["apache2"],
      }
      service { 'mumble-server':
          require => Package["mumble-server"],
      }
      service { 'samba':
          require => Package["samba"],
      }
      
}
