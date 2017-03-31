require_relative '../puppet_config'

module Deeploy
  module Config
    module Centos
      class PuppetConfig < Deeploy::Config::PuppetConfig

        def initialize(m_inst)
          @update_dependencies = "/usr/bin/yum update -y"
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
          @last_block = <<HERE

          #{@ufw_install}

          exec{"fix private network":
            command => "/usr/bin/nmcli connection reload && /bin/systemctl restart network.service",
            require => Exec['ssh-keygen']
          }

          exec{"add user to sudo":
            command => '/usr/sbin/usermod -aG wheel #{m_inst.vm_user}',
            require => User["#{m_inst.vm_user}"]
          }
HERE
          super(m_inst)
        end

      end
    end
  end
end