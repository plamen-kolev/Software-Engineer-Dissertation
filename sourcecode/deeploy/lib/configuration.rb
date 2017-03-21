module Deeploy
  module Config
    class Configuration < Configurable
      attr_reader :config
      attr_writer :path, :shell, :vagrant, :puppet
      @distro
      @ip
      @path
      @config

      def initialize(m_inst)
        super()

        # where the config file will be written to
        @path = m_inst.root
        @vm_name = m_inst.title
        @distro = m_inst.distribution
        @ip = m_inst.ip

      end

      def write(filename)

        # create pem certificate
        FileUtils.mkdir_p("#{@path}/.ssh")
        %x[ssh-keygen -t rsa -b 2048 -v -N '' -f #{@path}/.ssh/#{@vm_name}]
        File.rename("#{@path}/.ssh/#{@vm_name}", "#{@path}/.ssh/#{@vm_name}.pem")

        FileUtils.mkdir_p("#{@path}/manifests")
        File.open("#{filename}", 'w') { |file| 
          file.write("#{@config}")
        }
      end
    end
  end

end