require_relative '../puppet_config'

module Helper
  module Config
    module Centos
      class PuppetConfig < Helper::Config::PuppetConfig

        def initialize(m_inst)
          @update_dependencies = "/usr/bin/yum update -y"
          super(m_inst)
        end

      end
    end
  end
end