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
        @distro = m_inst.distribution
        @ip = m_inst.ip

      end

      def write(filename)
        FileUtils.mkdir_p("#{@path}/manifests")
        File.open("#{filename}", 'w') { |file| 
          file.write("#{@config}")
        }
      end
    end
  end

end