require "deeploy/version"
require "vm"
require "user"
require 'figaro'


module Deeploy
  config_path = "#{File.expand_path("#{File.dirname(__FILE__)}")}/../../config/application.yml"
  Figaro.application = Figaro::Application.new(environment: "development", path: config_path)
  Figaro.load
  $CONFIGURATION = Figaro.env

  def self.packages
    modules = ['vim', 'nginx', 'apache', 'mocp', 'xclock', 'x11', 'cinnamon']
    return modules
  end
end
