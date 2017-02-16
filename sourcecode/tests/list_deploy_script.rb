require "test/unit"
require "figaro"
require 'slugify'
require 'byebug'
require_relative '#{File.expand_path("#{File.dirname(__FILE__)}")}/../../lib/vm'

Figaro.application = Figaro::Application.new(environment: "test", path: "#{File.expand_path("#{File.dirname(__FILE__)}")}/../config/application.yml")
Figaro.load

module Testable
  class ListDeployScriptTest < Test::Unit::TestCase
    
    Helper::Configurable.new

    def test_list_machines()
      valid_user = Helper::User.authenticate(token: 'securetoken')
      
      valid_user.fetch_machines().each do | machine |
        puts machine
      end

    end

  end
end