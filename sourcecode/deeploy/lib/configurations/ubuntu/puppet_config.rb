require_relative '../puppet_config'

module Deeploy
  module Config
    module Ubuntu
      class PuppetConfig < Deeploy::Config::PuppetConfig

        def initialize(m_inst)
          @install_command = '/usr/bin/apt-get install'
          @last_block = <<HERE
          exec{"add user to sudo":
            command => '/usr/sbin/usermod -aG sudo #{m_inst.vm_user}',
            require => User["#{m_inst.vm_user}"]
          }
HERE
          super(m_inst)
        end

      end
    end
  end
end