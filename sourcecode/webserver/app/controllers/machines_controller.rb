class MachinesController < ApplicationController
  before_action :authenticate_user!

  def index 
    @machines = Machine.where(user_id: current_user.id)
    # do a ping test to see if machines alive

    @machines.each do |m|
      # alive checks the status of the machine and updates it
      # the end user will see the status
      vm = Deeploy::VM.get(title: m.title, owner: current_user)
      vm.alive()
    end


  end

  def destroy
    machine = Machine.find(params[:id])
    #
    logged_user = User.find(current_user.id)
    owner = ::Deeploy::User::authenticate(token: logged_user.token)
    # puts owner
    machine = ::Deeploy::VM.get(title: machine.title, owner: current_user)
    machine.destroy()
    redirect_to root_path
  end

  def new
    @machine = Machine.new
    # generate recommended name
    words = [
      "crosswind","epigenous","twelve","thorstein","loping",
      "rumble","ptain","challenged","divot","temper","derringer","feudalising","fantastically","rootage","sopolitical","undonated","noncontending","oversaturating","phonating","quadrating","quirites","unmounted","talkativeness","incondensable","concreting","caryatic"

    ]
    title = ""
    for i in 0..2
      title += "#{words.sample}-"
    end
    title += words.sample

    @machine.title = title
  end

  def create
    @machine = Machine.new(vm_params)
    packages = params[:machine][:packages]
    # pass packages, they are validated on model level
    if packages
      validate_packages(packages, @machine)
    end
    @machine.user_id = current_user.id
    if @machine.save()
      ::DeployWorker::perform_async(@machine.id)
      redirect_to root_path
    else
      render :new
    end
  end

  private
    def vm_params
        params.require(:machine).permit(:title, :body, :ports, :vm_user, :distribution, :packages => [])
    end

    def validate_packages(packages, machine)
      
      return true if not packages

      packages.each do |p|
        if machine.get_packages.include? p
          machine.errors.add(:packages, "#{p} is not a supported package")
        end
      end
    end

end
