class MachinesController < ApplicationController
  def destroy
    machine = Machine.find(params[:id])
    #
    owner = ::Deeploy::User::authenticate(token: current_user.token)
    # puts owner
    machine = ::Deeploy::VM.get(title: machine.title, owner: owner)

    machine.destroy()
    redirect_to root_path
  end

  def new
    @machine = Machine.new
  end

  def create
    @machine = Machine.new(vm_params)
    packages = params[:machine][:packages]
    # pass packages, they are validated on model level
    if packages
      validate_packages(packages, @machine)
    end
    puts current_user.inspect
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
