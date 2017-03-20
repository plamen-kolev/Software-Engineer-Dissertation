class MachineController < ApplicationController
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
    @packages = Deeploy::packages()
  end

  def create
    puts params.inspect
  end
end
