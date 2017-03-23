require 'sidekiq'
class DeployWorker
    include Sidekiq::Worker
    sidekiq_options :retry => 0
    def perform(vm_id)
      
      machine = Machine::find(vm_id)
      puts "\n\n"
      puts machine.inspect
      puts "\n\n"

      userobj = User.find(machine.user_id)
      deeploy_user = Deeploy::User::authenticate({token: userobj.token})

      begin
        deeploy_user = Deeploy::User::authenticate({token: userobj.token})

        machine = Deeploy::VM.create(
          distribution: machine.distribution,
          title: machine.title,
          owner: deeploy_user,
          vm_user: machine.vm_user,
          opts: {
            'packages' => machine.packages,
            'disk' => 0,
            'ports' => machine.ports,
            'ram' => 1
          }
        )
        machine.build()
      rescue Exception => e
        machine.destroy
      end
    end
end