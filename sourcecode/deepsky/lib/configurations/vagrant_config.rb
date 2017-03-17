module Helper
  module Config
    class VagrantConfig < Configuration

      def initialize(m_inst)
        @root = m_inst.root
        super(m_inst)
        @vbadditions = 'config.vbguest.auto_update = false' if ! @vbadditions
        @config = <<CONFIG
        Vagrant.configure(2) do |config|
          config.vm.box = "#{m_inst.distribution}"
          config.vm.network "private_network", ip: "#{m_inst.ip}", :bridge => '#{ENV['NETWORK_INTERFACE']}'
          config.vm.provision "shell", path: "manifests/setup.sh"
          config.vm.provision :puppet

          # from vbguest module
          #{@vbadditions}
          config.vm.provider "virtualbox" do |vb|
            vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
             vb.name = "#{m_inst.title}"
          end
        end
CONFIG
      end

      def write(file="")
        super("#{@path}/Vagrantfile")
      end
    end
  end
end