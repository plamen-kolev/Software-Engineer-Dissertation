require "test/unit"
require "figaro"
require 'slugify'
require 'byebug'
require_relative '#{File.expand_path("#{File.dirname(__FILE__)}")}/../../lib/vm'

Figaro.application = Figaro::Application.new(environment: "test", path: "#{File.expand_path("#{File.dirname(__FILE__)}")}/../config/application.yml")
Figaro.load

module Testable
  class NewDeployScriptTest < Test::Unit::TestCase
    
    Helper::Configurable.new    

    def test_new_vm_missmatched_user_object
      messages = capture_output do
        invalid_user = 'hello'
        machine = Helper::VM::create(distribution: 'ubuntu', title: 'ubuntu_test_box', owner: invalid_user, user: "ubuntuuser", password: "password")
        assert(!machine, "Expecting machine to be invalid due to non user object argument")
      end
      assert(messages[1].slugify == 'expecting-helper--user-object--got-string', 'Check if the right error message got spit out')
    end

    def test_new_vm_invalid_db_user
      messages = capture_output do

        invalid_user = Helper::User::authenticate(token: 'faketoken')
        machine = Helper::VM.create(distribution: 'ubuntu', title: 'ubuntu_test_box', owner: invalid_user, user: "ubuntuuser", password: "password")
        assert(!machine, "Expecting machine to be invalid due to fake database user")
      end

      assert(messages[1].slugify == 'invalid-tokenexpecting-helper--user-object--got-fixnum', 'Check if the right error message got spit out')
    end

    def test_new_vm_invalid_distribution
      messages = capture_output do
        valid_user = Helper::User.authenticate(token: 'securetoken')
        distribution = "invalidbuntu"
        machine = Helper::VM.create(distribution: distribution, title: 'ubuntu_test_box', owner: valid_user, user: "ubuntuuser", password: "password")
        assert(!machine, "Invalid machine, #{distribution} is not in the list")
      end

      assert(messages[1].slugify == 'distribution-invalidbuntu-is-not-a-recognized-option-options-are---ubuntu--debian--centos---aborting')
    end

    # # def test_new_vm_missing_arguments
    # #   assert(false)
    # # end

    def test_new_vm_successfull
      # first check if the machine already exists
      
      title = "ubuntu_test_box"
      valid_user = Helper::User.authenticate(token: 'securetoken')
      machine = Helper::VM.get(title: title, owner: valid_user)
      if machine
        machine.destroy
      end
      messages = capture_output do
        
        distribution = "ubuntu"
        machine = Helper::VM.create(distribution: distribution, title: title, owner: valid_user, user: "ubuntuuser", password: "password")
        assert(machine, "Invalid machine, #{distribution} is not in the list")
        machine.build
      end
      
    end

    # def get_or_create_machine()
    #   valid_user = Helper::User.authenticate(token: 'securetoken')
    #   machine = Helper::VM.get(title: "ubuntu_test_box", owner: valid_user)
    #   if machine
    #     return machine
    #   end
    #   machine = Helper::VM::create(distribution: "ubuntu", name: 'ubuntu_test_box', owner: valid_user, user: "ubuntuuser", password: "password")
    #   machine.build
    #   return machine
    # end
  end
end