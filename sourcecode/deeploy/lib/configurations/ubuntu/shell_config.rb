require_relative '../shell_config'

module Helper
  module Config
    module Ubuntu
      class ShellConfig < Helper::Config::ShellConfig
          
        def initialize(m_inst)
          super(m_inst)
        end

      end
    end
  end
end