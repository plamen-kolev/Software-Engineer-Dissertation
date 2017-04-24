require_relative 'puppet_config'

module Deeploy
  module Config
    # firewall manager will write the puppet instructions for
    # opening ports and installing the appropariate software
    class FirewallConfig < Deeploy::Config::PuppetConfig
      def initialize(m_inst)
        @config = ''
        @puppet_conf = [m_inst.manifest, 'default.pp'].join('/')
        @ports = m_inst.ports

        @config += <<HERE
        package {"ufw":
            ensure => 'installed',
            require => Exec['update_dependencies']
        }

        exec {'enable_monitorix_for_host':
          command => "/usr/sbin/ufw allow from #{Deeploy.network_interface[0]} proto tcp to any port 8080",
          require => Package['ufw']
        }

        # exec {"enable_firewall_rules":
        #   command => "/usr/sbin/ufw allow ssh && /usr/sbin/ufw allow 2222",
        #   require => Package['ufw']
        # }

        # exec {"enable_ufw":
        #   command => "/usr/sbin/ufw --force enable",
        #   require => Package["ufw"]
        # }
HERE

        if @ports
          @ports.each do |port|
            _open_port(port)
          end
        end
      end

      # specifies the puppet command for installing the firewall software
      def _open_port(port)
        @config += <<HERE
          exec {"enable_firewall_port_#{port}":
            command => "/usr/sbin/ufw allow #{port}",
            require => Package['ufw'],
            returns => [0,1]
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