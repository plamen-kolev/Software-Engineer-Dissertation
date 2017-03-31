require_relative '../puppet_config'

module Deeploy
  module Config
    module Ubuntu
      # firewall manager will write the puppet instructions for
      # opening ports and installing the appropariate software
      class FirewallConfig < Deeploy::Config::Ubuntu::PuppetConfig
        def initialize(m_inst)
          @config = ''
          @puppet_conf = [m_inst.manifest, 'default.pp'].join('/')
          @ports = m_inst.ports

          @config += <<HERE
          package {"ufw":
              ensure => 'installed',
              require => Exec['update_dependencies']
          }

          exec {"enable_firewall_rules":
            command => "/usr/sbin/ufw allow ssh && /usr/sbin/ufw allow 2222",
            require => Package['ufw']
          }

          exec {"enable_ufw":
            command => "/usr/sbin/ufw --force enable",
            require => Package["ufw"]
          }
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
              require => Package['ufw']
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