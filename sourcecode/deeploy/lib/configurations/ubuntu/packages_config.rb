module Deeploy
  module Config
    module Ubuntu
      # firewall manager will write the puppet instructions for
      # opening ports and installing the appropariate software
      class PackagesConfig < Deeploy::Config::Ubuntu::PuppetConfig
        def initialize(m_inst)
          super(m_inst)
          @puppet_conf = [m_inst.manifest, 'default.pp'].join('/')
          @config = ''
          @packages = m_inst.packages
          return self unless @packages

          @packages.each do |package|
            case package
              when 'vim'
                install_vim
              when 'nginx'
                install_nginx
              when 'apache2'
                install_apache
              when 'mysql'
                install_mysql
              when 'memcached'
                install_memcached
            end
          end

        end

        def install_vim
          @config += <<HERE
          package { "vim":
            ensure => 'installed',#
            require => Exec['update_dependencies']
          }
HERE
        end

        def install_nginx
          @config += <<HERE
          package { "nginx":
            ensure => 'installed',#
            require => Exec['update_dependencies']
          }
HERE
        end

        def install_apache
          @config += <<HERE
          package { "apache2":
            ensure => 'installed',#
            require => Exec['update_dependencies']
          }
HERE
        end

        def install_mysql
          @config += <<HERE
          file_line { "mysql":
            path  => '/etc/mysql/mysql.conf.d/mysqld.cnf',
            line  => 'bind-address           = 0.0.0.0',
            match => '^bind-address',
            notify  => Service["mysql"],
            require => Package["mysql-server"]
          }

          package { "mysql-server":
            ensure => 'installed',#
            require => Exec['update_dependencies']
          }

          service { "mysql":
            ensure  => 'running',
            enable  => true,
            require => Package["mysql-server"],
          }
HERE
        end

        def install_memcached
          @config += <<HERE
              file_line { "memcached":
                notify  => Service["memcached"], 
                path  => '/etc/memcached.conf',
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

        def write
          File.open(@puppet_conf, 'a') do |f|
            f.puts(@config)
          end
        end

      end
    end
  end
end