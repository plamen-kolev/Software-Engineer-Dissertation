require_relative 'configuration'
# require_relative 'configurations/shell_config'
# require_relative 'configurations/vagrant_config'
# require_relative 'configurations/puppet_config'

module Helper
  class Confmanager < Configurable

    def initialize(vm)
      @requires = {
        # name of the distribution => [path to files, namespace]
        'ubuntu/xenial64' => {
          module: 'configurations/ubuntu', 
          class: 'Helper::Config::Ubuntu'
        },

        'bento/centos-7.2' => {
          module: 'configurations/centos', 
          class: 'Helper::Config::Centos'
        },

        config: {'puppet_config' => 'PuppetConfig', 'shell_config' => 'ShellConfig', 'vagrant_config' => 'VagrantConfig'}
      }
      
      # dynamically resolve dependencies for each distribution
      dependencies = @requires[vm.distribution]

      @requires[:config].each do | key, value |
        require_relative "#{dependencies[:module]}/#{key}"
        cls = Object.const_get("#{dependencies[:class]}::#{value}").new(vm)
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
