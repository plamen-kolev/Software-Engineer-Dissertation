require 'sidekiq'

class DeployUpWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0
  def perform(vm_id)
    machine = Machine.find(vm_id)
    current_user = User.find(machine.user_id)
    machine = Deeploy::VM.get(title: machine.title, owner: current_user)
    machine.up()
  end
end