require_relative '../packages_config'

module Deeploy
  module Config
    module Centos
      # firewall manager will write the puppet instructions for
      # opening ports and installing the appropariate software
      class PackagesConfig < Deeploy::Config::PackagesConfig
        def initialize(m_inst)
          @puppet_conf = [m_inst.manifest, 'default.pp'].join('/')
          @config = ''
          @packages = m_inst.packages
          return self unless @packages
          install_packages(@packages)
        end

        def install_vim
          @config += <<HERE
            package { "vim-enhanced":
              ensure => 'installed',#
              require => [Exec['update_dependencies'], Package['epel-release']]
            }
HERE
        end


        def install_nginx
          @config += <<HERE
          package { "nginx":
            ensure => 'installed',#
            require => [Exec['update_dependencies'], Package['epel-release']]
          }
          
          service { "nginx":
            ensure  => 'running',
            enable  => true,
            require => Package["nginx"],
          }
HERE
        end

        def install_memcached
          @config += <<HERE
            file_line { "memcached":
              notify  => Service["memcached"],
              path  => '/etc/sysconfig/memcached',
              line  => '-l 0.0.0.0',
              match => '^-l 127.0.0.1',
              require => Package["memcached"]
            }
            service { "memcached":
              ensure  => 'running',
              enable  => true,
              require => Package["memcached"],
            }

            package { "memcached":
              ensure => 'installed',#
              require => Exec['update_dependencies']
            }
HERE
        end

        def install_mysql
          @config += <<HERE

          # exec {"download-mysql-rpm":
          #   command => "/usr/bin/wget -nc https://repo.mysql.com/mysql57-community-release-el7-9.noarch.rpm -O /root/mysql.rpm"
          # }

          #package { 'mysql-libs':
          #  ensure => 'purged',
          #}

          #package {"mysql57-community-release":
          #  source => "https://repo.mysql.com/mysql57-community-release-el7-9.noarch.rpm",
          #  provider => 'rpm',
          #  ensure => installed,
          #  require => [Package['mysql-libs']],
          #}

          package {"mysql-community-server":
            ensure => installed,
          #  require => Package['mysql57-community-release']
          }

          file_line { "mysql":
            path  => '/etc/my.cnf',
            line  => 'bind-address           = 0.0.0.0',
            # match => '^bind-address',
            notify  => Service["mysqld"],
            require =>Package['mysql-community-server']
          }

          service { "mysqld":
            ensure  => 'running',
            enable  => true,
            require => Package['mysql-community-server']
          }
HERE
        end
      end
    end
  end
end