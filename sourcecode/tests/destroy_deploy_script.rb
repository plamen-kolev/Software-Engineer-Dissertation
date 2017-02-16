require "test/unit"
require "figaro"
require 'slugify'
require 'byebug'
require_relative '#{File.expand_path("#{File.dirname(__FILE__)}")}/../../lib/vm'

Figaro.application = Figaro::Application.new(environment: "test", path: "#{File.expand_path("#{File.dirname(__FILE__)}")}/../config/application.yml")
Figaro.load

module Testable
  class DestroyDeployScriptTest < Test::Unit::TestCase
    
    Helper::Configurable.new

    def test_destroy_machine()
      machine = get_or_create_machine()
      machine.destroy
    end

    def get_or_create_machine()
      valid_user = Helper::User.authenticate(token: 'securetoken')
      machine = Helper::VM.get(title: "ubuntu_test_box", owner: valid_user)
      if machine
        return machine
      end
      machine = Helper::VM::create(distribution: "ubuntu", name: 'ubuntu_test_box', owner: valid_user, user: "ubuntuuser", password: "password")
      machine.build
      return machine
    end

  end
end