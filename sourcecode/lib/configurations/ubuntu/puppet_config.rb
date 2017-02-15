require_relative '../puppet_config'

module Helper
  module Config
    module Ubuntu
      class PuppetConfig < Helper::Config::PuppetConfig

        def initialize(m_inst)
          @last_block = <<HERE
          exec{"add user to sudo":
            command => '/usr/sbin/usermod -aG sudo #{m_inst.user}',
            require => User["#{m_inst.user}"]
          }
HERE
          super(m_inst)
        end

      end
    end
  end
end