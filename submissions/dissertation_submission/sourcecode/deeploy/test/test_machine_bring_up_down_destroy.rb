ENV['deeploy_env'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'deeploy'

class TestDeeployStaticMethods < Minitest::Test
  def setup
    # get the machine, if none, create it
    @title = 'unique_machine'
    @user = DB::User.find(1)
    @distribution = 'ubuntu'
    @vm_user = 'mainuser'
    @db_machine = DB::Machine.first

    @machine = Deeploy::VM.get(title: @title, owner: @user)
    unless @machine
      @machine = Deeploy::VM.new(
        distribution: 'ubuntu',
        title: @title,
        owner: @user,
        vm_user: @vm_user,
      )
      @machine.build()
    end
  end

  def test_bring_machine_down
    @machine.up()
    assert(@machine.alive?, "Expecting machine #{@machine.title} to be up and running, but it was not")
    @machine.down()
    assert(!@machine.alive?, "Expecting machine #{@machine.title} to be not running after turning it off")
  end

  def test_bring_machine_up
    @machine.down()
    assert(!@machine.alive?, "Expecting machine #{@machine.title} to be not running after turning it off")
    @machine.up
    assert(@machine.alive?, "Expecting machine #{@machine.title} to be up and running, but it was not")
  end

  def test_destroy_machine
    assert(false, "ISNTEAD OF MACHINE ALIVE, use netssh to test,as the instance goes away")
    @machine.up()
    assert(@machine.alive?, "Expecting machine #{@machine.title} to be not running")
    @machine.destroy()
    assert(!@machine.alive?, "Expecting machine #{@machine.title} to be destroyed")
    assert(!Dir.exist?(@root), "Expecting folder #{@root} to be destroyed")

  end
end