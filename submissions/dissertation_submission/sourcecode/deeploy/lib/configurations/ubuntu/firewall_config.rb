require_relative '../firewall_config'

module Deeploy
  module Config
    module Ubuntu
      # firewall manager will write the puppet instructions for
      # opening ports and installing the appropariate software
      class FirewallConfig < Deeploy::Config::FirewallConfig
        def initialize(m_inst)
          super(m_inst)
        end
      end
    end
  end
end