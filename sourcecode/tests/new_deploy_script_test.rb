require "test/unit"
require "figaro"
require_relative '#{File.expand_path("#{File.dirname(__FILE__)}")}/../../lib/vm'

Figaro.application = Figaro::Application.new(environment: "development", path: "#{File.expand_path("#{File.dirname(__FILE__)}")}/../config/application.yml")
Figaro.load

module Testable
  class NewDeployScriptTest < Test::Unit::TestCase
    
    Helper::Configurable.new
    
    # def test_new_vm_missmatched_user_object
    #   invalid_user = 'hello'
    #   machine = Helper::VM.new(distribution: 'ubuntu', name: 'ubuntu_test_box', owner: invalid_user, user: "ubuntuuser", password: "password")
    #   assert(!machine.valid, "Expecting machine to be invalid due to non user object argument")
    # end

    # def test_new_vm_invalid_db_user
    #   # init db
      
    #   invalid_user = DB::User.new
    #   machine = Helper::VM.new(distribution: 'ubuntu', name: 'ubuntu_test_box', owner: invalid_user, user: "ubuntuuser", password: "password")
    #   assert(!machine.valid, "Expecting machine to be invalid due to fake database user")
    # end

    def test_new_vm_invalid_distribution
      stdout = capture_output do
        valid_user = DB::User.where(email: "local@host.com").take
        distribution = "invalidbuntu"
        machine = Helper::VM.new(distribution: 'ubuntu', name: 'ubuntu_test_box', owner: valid_user, user: "ubuntuuser", password: "password")
        assert(!machine.valid, "Invalid machine, #{distribution} is not in the list")
      end
      
    end

    # def test_new_vm_missing_arguments
    #   assert(false)
    # end

    # def test_new_vm_successfull
    #   assert(false)
    # end

  end
end