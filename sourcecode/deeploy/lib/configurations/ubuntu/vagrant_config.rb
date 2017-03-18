require_relative '../vagrant_config'

module Deeploy
  module Config
    module Ubuntu
      class VagrantConfig < Deeploy::Config::VagrantConfig
    

        def initialize(m_inst)
          super(m_inst)
        end

      end
    end
  end
end