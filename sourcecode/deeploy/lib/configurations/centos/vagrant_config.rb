require_relative '../vagrant_config'

module Deeploy
  module Config
    module Centos
      class VagrantConfig < Deeploy::Config::VagrantConfig
        def initialize(m_inst)
          @vbadditions = '# config.vbguest.auto_update = false'
          super(m_inst)
        end

      end
    end
  end
end
