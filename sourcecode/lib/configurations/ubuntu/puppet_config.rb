require_relative '../puppet_config'

module Helper
  module Config
    module Ubuntu
      class PuppetConfig < Helper::Config::PuppetConfig

        def initialize(m_inst)
          super(m_inst)
        end

      end
    end
  end
end