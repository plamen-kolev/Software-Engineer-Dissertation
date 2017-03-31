module Deeploy
  module Config
    class PuppetConfig < Configuration

      def initialize(m_inst)
        @distribution = m_inst.distribution
        @machine = m_inst
        @root = m_inst.root
        @update_dependencies = "/usr/bin/apt-get update"  if ! @update_dependencies
        @install_package_command = create_install_packages_config(m_inst.packages)
        @ufw_install = <<HERE
        package {"ufw":
          ensure => 'installed',
          require => Exec['update_dependencies']
        }
HERE
        @open_ports_command = open_ports_config(m_inst.ports.collect{|el| el.to_i})

        super(m_inst)
        @config = <<CONF
          include 'stdlib'

          #{@install_package_command}
          #{@open_ports_command}
          

          exec {"coppy_private_key_to_authorised_keys":
            command => "/bin/cat /vagrant/.ssh/#{@machine.title}.pub >> /home/#{@machine.vm_user}/.ssh/authorized_keys",
            user        => "#{@machine.vm_user}",
          }

          exec {"current_user_will_not_require_password":
            command => "/bin/echo '#{@machine.vm_user} ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers"
          }

          exec {"update_dependencies":
            command => '#{@update_dependencies}',
          }


          exec {"enable_firewall_rules":
            command => "/usr/sbin/ufw allow ssh && /usr/sbin/ufw allow 2222",
            require => Package['ufw']
          }

          exec {"enable_ufw":
            command => "/usr/sbin/ufw --force enable",
            require => Package["ufw"]
          }

          user { "#{@machine.vm_user}":
            ensure           => 'present',
            # gid              => '501',
            home             => "/home/#{@machine.vm_user}",

            # password_max_a ge => '99999',
            # password_min_age => '0',
            shell            => '/bin/bash',
            managehome  => true,
            system => true,
            uid              => '501',
          }

          # setup ssh keys for new user
          exec {"ssh-keygen":
            command => "/usr/bin/ssh-keygen -t rsa -N '' -f /home/#{@machine.vm_user}/.ssh/id_rsa",
            user        => "#{@machine.vm_user}",
            returns => [0,1],
            require => User['#{@machine.vm_user}'],
          }

          #{@last_block}
CONF

      end
      
      def create_install_packages_config(packages)
        config = ""

        packages.each do |p|
          package = Deeploy.packages()[p.to_sym][@distribution.to_sym]
          # make mysql listen on 0.0.0.0 if installed
          if p == "mysql"
            # mysql is called mariadb in centos

            config += <<HERE

              file_line { "#{package}":
                path  => '/etc/mysql/mysql.conf.d/mysqld.cnf',
                line  => 'bind-address           = 0.0.0.0',
                match => '^bind-address',
                notify  => Service["mysql"], 
                require => Package["#{package}"]
              }
              
              service { "mysql":
                ensure  => 'running',
                enable  => true,
                require => Package["#{package}"],
              }
HERE
          end

          if p == "memcached"
            config += <<HERE
              file_line { "#{package}":
                notify  => Service["#{p}"], 
                path  => '/etc/memcached.conf',
                line  => '-l 0.0.0.0',
                match => '^-l 127.0.0.1',
                require => Package["#{p}"]
              }
              service { "#{package}":
                ensure  => 'running',
                enable  => true,
                require => Package["#{package}"],
              }
HERE
          end

          config += <<HERE
            package { "#{package}":
              ensure => 'installed',#
              require => Exec['update_dependencies']
            }
HERE
        end

        return config
      end

      def open_ports_config(ports)
        config = ""

        ports.each do |p|
          config += <<HERE
          exec {"enable_firewall_port_#{p}":
            command => "/usr/sbin/ufw allow #{p}",
            require => Package['ufw']
          }

HERE
        end

        return config
      end

      def write(file='')
        super("#{@path}/manifests/default.pp")
      end
    end
  end
end
