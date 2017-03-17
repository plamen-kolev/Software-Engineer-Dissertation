class MachineController < ApplicationController
  def destroy
    # ::Helper::Configurable.new
    machine = Machine.find(params[:id])
    #
    owner = ::Helper::User::authenticate(token: current_user.token)
    # puts owner
    m = ::Helper::VM.get(title: machine.title, owner: owner)
    puts m
    m.destroy()
  end
end
