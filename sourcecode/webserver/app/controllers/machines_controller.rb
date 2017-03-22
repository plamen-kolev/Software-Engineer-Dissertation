class MachinesController < ApplicationController
  def destroy
    machine = Machine.find(params[:id])
    #
    owner = ::Deeploy::User::authenticate(token: current_user.token)
    # puts owner
    m = ::Deeploy::VM.get(title: machine.title, owner: owner)

    m.destroy()
    redirect_to root_path
  end

  def new
    @machine = Machine.new
  end

  def create
    @machine = Machine.new(vm_params)
    # pass packages, they are validated on model level
    if params[:machine][:packages]
      packages = params[:machine][:packages]
      validate_packages(packages, @machine)
    end

    if @machine.save()
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
