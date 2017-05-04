require_relative 'configuration'

module Deeploy
  class Confmanager < Configurable

    def initialize(vm)
      @shell_config = nil
      @vagrant_config = nil
      @puppet_config = nil
      @packages_config = nil

      @requires = {
        # name of the distribution => [path to files, namespace]
        'ubuntu' => {
          module: 'configurations/ubuntu',
          class: 'Deeploy::Config::Ubuntu',
          firewall_config_class: 'Deeploy::Config::Ubuntu::FirewallConfig',
          packages_config_class: 'Deeploy::Config::Ubuntu::PackagesConfig'
        },

        'centos' => {
          module: 'configurations/centos',
          class: 'Deeploy::Config::Centos',
          firewall_config_class: 'Deeploy::Config::Centos::FirewallConfig',
          packages_config_class: 'Deeploy::Config::Centos::PackagesConfig'
        },

        'debian' => {
            module: 'configurations/debian',
            class: 'Deeploy::Config::Debian',
            firewall_config_class: 'Deeploy::Config::Debian::FirewallConfig',
            packages_config_class: 'Deeploy::Config::Debian::PackagesConfig'
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

      # load firewall configuration for the distribution and set it up
      require_relative ['configurations', vm.distribution, 'firewall_config'].join('/')
      firewall_config_class = @requires[vm.distribution][:firewall_config_class]
      @firewall_config = Object.const_get(firewall_config_class).new(vm)

      # load package configuration
      require_relative ['configurations', vm.distribution, 'packages_config'].join('/')
      packages_config_class = @requires[vm.distribution][:packages_config_class]
      @packages_config = Object.const_get(packages_config_class).new(vm)


    end

    def get_puppet_conf
      return @puppet_config
    end

    def writeall
      # child of configuration, can setup ssh and folders
      @shell_config.setup_ssh
      @shell_config.setup_folders

      @shell_config.write
      @puppet_config.write
      @vagrant_config.write
      @firewall_config.write
      @packages_config.write
    end
  end

end
