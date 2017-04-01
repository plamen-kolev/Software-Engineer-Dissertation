require_relative '../firewall_config'

module Deeploy
  module Config
    module Centos
      # firewall manager will write the puppet instructions for
      # opening ports and installing the appropariate software
      class FirewallConfig < Deeploy::Config::FirewallConfig
        def initialize(m_inst)
          @config = ''
          @puppet_conf = [m_inst.manifest, 'default.pp'].join('/')
          @ports = m_inst.ports

          @config += <<HERE
          package {"ufw":
            ensure => 'installed',
            require => [Exec['update_dependencies'], Package['epel-release']]
          }

          package {"epel-release":
            ensure => "installed",
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
      end
    end
  end
end