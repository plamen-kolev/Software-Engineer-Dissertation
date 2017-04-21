module Deeploy
  module Config
    class VagrantConfig < Configuration

      def initialize(m_inst)
        @root = m_inst.root
        super(m_inst)
        @vbadditions ||= 'config.vbguest.auto_update = false'

        distribution = Deeploy.distributions()
        sym = m_inst.distribution.to_sym
        distribution = distribution[sym]

        @config = <<CONFIG
        Vagrant.configure(2) do |config|
          config.ssh.insert_key = false
          config.vm.box = "#{distribution}"
          config.vm.network "private_network", ip: "#{m_inst.ip}", :bridge => '#{$CONFIGURATION.network_interface}'
          config.vm.provision "shell", path: "manifests/setup.sh"
          config.vm.provision :puppet

          # from vbguest module
          #{@vbadditions}
          config.vm.provider "virtualbox" do |vb|
            vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
            vb.name = "#{m_inst.title}"
            vb.memory = "#{m_inst.ram * 1024}"
          end
        end
CONFIG
      end

      def write
        super("#{@path}/Vagrantfile")
      end
    end
  end
end
