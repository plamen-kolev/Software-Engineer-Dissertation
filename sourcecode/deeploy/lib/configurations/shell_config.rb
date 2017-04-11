module Deeploy
  module Config
    class ShellConfig < Configuration

      def initialize(m_inst)
        @install_puppet ||= '/usr/bin/apt-get install puppet -y'
        super(m_inst)
        @config = <<CONFIG
          #{@install_puppet}
          /usr/bin/puppet module install puppetlabs-stdlib
          # puppet module install puppetlabs-mysql
          # puppet module install puppetlabs-vcsrepo
CONFIG
      end

      def write()
        super("#{@path}/manifests/setup.sh")
      end
    end
  end
end