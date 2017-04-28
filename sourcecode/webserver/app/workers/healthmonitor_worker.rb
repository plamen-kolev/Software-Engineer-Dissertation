require 'sidekiq'
class HealthmonitorWorker
  include Sidekiq::Worker

  def perform
    machines = Machine.all
    machines.each do |m|
      m.alive = Deeploy.alive(m.ip)
      m.save()
    end
  end
end