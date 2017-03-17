require_relative '../shell_config'

module Helper
  module Config
    module Centos
      class ShellConfig < Helper::Config::ShellConfig
          
        def initialize(m_inst)
          @install_puppet = [
            '/usr/bin/rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm', 
            '/usr/bin/yum install puppet -y'
          ].join(' && ')

          super(m_inst)
        end

      end
    end
  end
end