require_relative '../shell_config'

module Deeploy
  module Config
    module Debian
      class ShellConfig < Deeploy::Config::ShellConfig
          
        def initialize(m_inst)
          super(m_inst)
        end

      end
    end
  end
end