require_relative 'configuration'
# require_relative 'configurations/shell_config'
# require_relative 'configurations/vagrant_config'
# require_relative 'configurations/puppet_config'

module Deeploy
  class Confmanager < Configurable

    def initialize(vm)
      @requires = {
        # name of the distribution => [path to files, namespace]
        'ubuntu' => {
          module: 'configurations/ubuntu',
          class: 'Deeploy::Config::Ubuntu'
        },

        'centos' => {
          module: 'configurations/centos', 
          class: 'Deeploy::Config::Centos'
        },

        config: {'puppet_config' => 'PuppetConfig', 'shell_config' => 'ShellConfig', 'vagrant_config' => 'VagrantConfig'}
      }

      # dynamically resolve dependencies for each distribution
      dependencies = @requires[vm.distribution]

      @requires[:config].each do |key, value|
        require = [dependencies[:module], key].join('/')
        require_relative require
        class_ref = "#{dependencies[:class]}::#{value}"
        cls = Object.const_get(class_ref).new(vm)
        self.instance_variable_set("@#{key}", cls)
      end

    end

    def writeall(args = {})
      @shell_config.write(args[:shell])
      @puppet_config.write(args[:puppet])
      @vagrant_config.write(args[:vagrant])
    end
  end

end
