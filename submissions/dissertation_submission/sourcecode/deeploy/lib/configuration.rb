module Deeploy
  module Config
    class Configuration < Configurable
      attr_reader :config
      attr_writer :path, :shell, :vagrant, :puppet
      # @distro
      # @ip
      # @path
      # @config

      def initialize(m_inst)
        # @@ssh_needs_configuring = true
        # @@manifest_folder_needs_creating = true
        super()

        # where the config file will be written to
        @path = m_inst.root
        @vm_name = m_inst.title
        @distro = m_inst.distribution
        @ip = m_inst.ip
      end

      # when configuration writes, it will setup ssh,
      # ensure that happens only once

      def setup_ssh
        # create pem certificate
        FileUtils.mkdir_p("#{@path}/.ssh")
        %x(ssh-keygen -t rsa -b 2048 -v -N '' -f #{@path}/.ssh/#{@vm_name})
        # File.rename("#{@path}/.ssh/#{@vm_name}", "#{@path}/.ssh/#{@vm_name}.pem")
        File.rename(
          [@path, '.ssh', @vm_name].join('/'),
          [@path, '.ssh', "#{@vm_name}.pem"].join('/'))
      end

      def setup_folders
        FileUtils.mkdir_p("#{@path}/manifests")
      end

      def write(filename)
        File.open(filename, 'w') { |file|
          file.write(@config)
        }
      end
    end
  end

end