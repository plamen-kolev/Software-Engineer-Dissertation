module Deeploy
  module Config
    class PuppetConfig < Configuration

      def initialize(m_inst)
        @distribution = m_inst.distribution
        @machine = m_inst
        @root = m_inst.root
        @update_dependencies = '/usr/bin/apt-get update'  unless @update_dependencies

        super(m_inst)
        @config = <<CONF
          include 'stdlib'

          #{@install_package_command}

          exec {"copy_private_key_to_authorised_keys":
            command => "/bin/cat /vagrant/.ssh/#{@machine.title}.pub >> /home/#{@machine.vm_user}/.ssh/authorized_keys",
            user        => "#{@machine.vm_user}",
          }

          exec {"current_user_will_not_require_password":
            command => "/bin/echo '#{@machine.vm_user} ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers"
          }

          exec {"update_dependencies":
            command => '#{@update_dependencies}',
            returns => [0,100]
          }

          user { "#{@machine.vm_user}":
            ensure           => 'present',
            # gid              => '501',
            home             => "/home/#{@machine.vm_user}",

            # password_max_a ge => '99999',
            # password_min_age => '0',
            shell            => '/bin/bash',
            managehome  => true,
            system => true,
            uid              => '501',
          }

          # setup ssh keys for new user
          exec {"ssh-keygen":
            command => "/usr/bin/ssh-keygen -t rsa -N '' -f /home/#{@machine.vm_user}/.ssh/id_rsa",
            user        => "#{@machine.vm_user}",
            returns => [0,1],
            require => User['#{@machine.vm_user}'],
          }

          #{@last_block}
CONF

      end

      def write
        super("#{@path}/manifests/default.pp")
      end
    end
  end
end
