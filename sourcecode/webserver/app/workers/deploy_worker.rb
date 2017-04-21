require 'sidekiq'
class DeployWorker
    include Sidekiq::Worker
    sidekiq_options :retry => 0
    def perform(vm_id)
      machine = Machine.find(vm_id)
      current_user = User.find(machine.user_id)
      packages = machine.packages.split(",").collect{|el| el.strip}
      ports = machine.ports.split(',').collect{|el| el.strip.to_i}

      machine = Deeploy::VM.get(title: machine.title, owner: current_user)
      machine.build()
    end
end