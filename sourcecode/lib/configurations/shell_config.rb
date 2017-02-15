module Helper
  module Config
    class ShellConfig < Configuration

      

      def initialize(m_inst)
        @install_puppet = "/usr/bin/apt-get install puppet -y" if ! @install_puppet  
        super(m_inst)
        @config = <<CONFIG
          #{@install_puppet}
          /usr/bin/puppet module install puppetlabs-stdlib
          /usr/bin/puppet module install saz-sudo

          # puppet module install puppetlabs-mysql
          # puppet module install puppetlabs-vcsrepo
CONFIG
      end

      def write(file='')
        super("#{@path}/manifests/setup.sh")
      end
    end
  end
end