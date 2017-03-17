require_relative '../vagrant_config'

module Helper
  module Config
    module Ubuntu
      class VagrantConfig < Helper::Config::VagrantConfig
    

        def initialize(m_inst)
          super(m_inst)
        end

      end
    end
  end
end