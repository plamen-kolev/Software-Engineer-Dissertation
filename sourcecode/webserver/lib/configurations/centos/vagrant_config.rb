require_relative '../vagrant_config'

module Helper
  module Config
    module Centos
      class VagrantConfig < Helper::Config::VagrantConfig
    
        def initialize(m_inst)
          @vbadditions = 'config.vbguest.auto_update = false'
          super(m_inst)
        end

      end
    end
  end
end