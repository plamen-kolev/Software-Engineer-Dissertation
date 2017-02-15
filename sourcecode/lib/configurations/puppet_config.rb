module Helper
  module Config
    class PuppetConfig < Configuration
      
      def initialize(m_inst)
        @root = m_inst.root
        @update_dependencies = "/usr/bin/apt-get update"  if ! @update_dependencies
        
        super(m_inst)
        @config = <<CONF
          include 'stdlib'

          exec {"update_dependencies":
            command => '#{@update_dependencies}'
          }

          user { "#{m_inst.user}":
            ensure           => 'present',
            # gid              => '501',
            home             => "/home/#{m_inst.user}",
            password         =>   pw_hash('#{m_inst.password}', 'SHA-512', 'mysalt'),
            # password_max_a ge => '99999',
            # password_min_age => '0',
            shell            => '/bin/bash',
            managehome  => true,
            system => true,
            uid              => '501',
          }

          # setup ssh keys for new user
          exec {"ssh-keygen":
            command => "/usr/bin/ssh-keygen -t rsa -N '' -f /home/#{m_inst.user}/.ssh/id_rsa",
            user        => "#{m_inst.user}",
            returns => [0,1],
            require => User['#{m_inst.user}'],

          }

          #{@last_block}
CONF
      end

      def write(file='')
        super("#{@path}/manifests/default.pp")
      end

      def setup_privileges()
#         FileUtils.mkdir_p("#{@path}/manifests")

#         privileges = <<-HERE
#           class privileges {

#             sudo::conf { 'admins':
#               ensure  => present,
#               content => '%admin ALL=(ALL) ALL',
#             }

#           }
# HERE

#         File.open([@root, 'manifests', 'init.pp'].join('/'), 'w') { |file| 
#           file.write(privileges)
#         }
      end
    end
  end
end