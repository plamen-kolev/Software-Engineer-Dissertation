require_relative '../puppet_config'

module Helper
  module Config
    module Centos
      class PuppetConfig < Helper::Config::PuppetConfig

        def initialize(m_inst)
          @update_dependencies = "/usr/bin/yum update -y"
          @last_block = <<HERE
          exec{"fix private network":
            command => "/usr/bin/nmcli connection reload && /bin/systemctl restart network.service",
            require => Exec['ssh-keygen']
          }

          exec{"add user to sudo":
            command => '/usr/sbin/usermod -aG wheel #{m_inst.user}',
            require => User["#{m_inst.user}"]
          }
HERE
          super(m_inst)
        end

      end
    end
  end
end