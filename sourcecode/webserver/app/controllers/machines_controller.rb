

class MachinesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_machine, only: [:show, :up, :down, :restart, :destroy, :down_wait, :up_wait, :destroy_wait, :restart_wait, :build_wait, :status]

  def index
    @machines = Machine.where(user_id: current_user.id)
    @machines.each do |m|
      vm = Deeploy::VM.get(title: m.title, owner: current_user)
    end
  end

  def show
  end

  def destroy
    # params.require(:machine_title)
    ::DeployDestroyWorker.perform_async(@machine.id)
    redirect_to machine_destroy_wait_path
  end

  def destroy_wait; end


  def new
    @machine = Machine.new
    @machine.vm_user = 'user'
    @machine.ram = 500
    # generate recommended name
    words = [
      "crosswind","epigenous","twelve","thorstein","loping",
      "rumble","ptain","challenged","divot","temper","derringer","feudalising","fantastically","rootage","sopolitical","undonated","noncontending","oversaturating","phonating","quadrating","quirites","unmounted","talkativeness","incondensable","concreting","caryatic"
    ]

    title = ''
    for i in 0..2
      title += "#{words.sample}-"
    end
    title += words.sample

    @machine.title = title
  end

  def create
    @machine = Machine.new(vm_params())
    packages = params[:machine][:packages]
    # pass packages, they are validated on model level
    if packages
      validate_packages(packages)
      @machine.packages = packages.join(",")
    end
    @machine.user_id = current_user.id

    if @machine.save()
      ::DeployWorker::perform_async(@machine.id)
      redirect_to machine_build_wait_path(@machine.title)
    else
      render :new
    end
  end

  def build_wait;
    puts "blunthell"
    puts @machine.inspect
  end

  def status
    if not @machine
      render json: {status: false, exists: false}
    else
      m = Deeploy::VM.get(title: @machine.title, owner: current_user)
      render json: {status: @machine.alive?, exists: true, build: m.stage}
    end
  end

  def download_certificate
    params.require(:machine_title)    
    @machine = ::Deeploy::VM.get(title: params[:machine_title], owner: current_user)
    m = Machine.find(@machine.id)
    if not m.pem
      raise ActionController::RoutingError.new('Not Found')
    end
    m.pem = nil
    m.save()

    send_file [@machine.root, '.ssh', "#{@machine.title}.pem"].join('/')
    # send_data pem,
    #   :type => 'text/plain; charset=UTF-8;',
    #   :disposition => "attachment; filename=#{@machine.title}.pem"

  end

  def down
    ::DeployHaltWorker::perform_async(@machine.id)
    redirect_to machine_down_wait_path
  end

  def down_wait; end

  def up
    ::DeployUpWorker::perform_async(@machine.id)
    redirect_to machine_up_wait_path
  end

  def up_wait; end

  def restart
    ::DeployRestartWorker::perform_async(@machine.id)
    redirect_to machine_restart_wait_path
  end

  def restart_wait; end

  private

    def get_machine
      params.require(:machine_title)
      @machine = ::Deeploy::VM.get(title: params[:machine_title], owner: current_user)
    end

    def vm_params
      params.require(:machine).permit(:title, :body, :ports, :vm_user, :distribution, :ram, :packages => [])
    end

    def validate_packages(packages)
      allowed_packages = Deeploy::packages()
      return true if not packages

      packages.each do |p|
        if allowed_packages.include? p
          @machine.errors.add(:packages, "#{p} is not a supported package")
        end
      end
    end

end
