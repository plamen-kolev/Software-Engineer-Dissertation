require "deeploy/version"
require "vm"
require "user"

module Deeploy
  def self.packages
    modules = ['vim', 'nginx', 'apache', 'mocp', 'xclock', 'x11', 'cinnamon']
    return modules
  end
end
