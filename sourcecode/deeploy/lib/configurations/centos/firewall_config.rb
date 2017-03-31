@ufw_install = <<HERE
          package {"ufw":
            ensure => 'installed',
            require => [Exec['update_dependencies'], Package['epel-release']]
          }

          package {"epel-release":
            ensure => "installed",
            require => Exec['update_dependencies']
          }
HERE