require "deeploy/version"
require "vm"
require "user"
require 'figaro'


module Deeploy
  config_path = "#{File.expand_path("#{File.dirname(__FILE__)}")}/../../config/application.yml"
  Figaro.application = Figaro::Application.new(environment: "development", path: config_path)
  Figaro.load
  $CONFIGURATION = Figaro.env

  # initialize environmental variables
  @sqlite_root = $CONFIGURATION.db_path ||= "#{File.expand_path("#{File.dirname(__FILE__)}")}/../db/"

  if $CONFIGURATION.rails_env == 'development'
    ActiveRecord::Base.establish_connection(
      adapter:  $CONFIGURATION.database_adapter, # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
      database: [@sqlite_root,'development.sqlite3'].join('/'),
    )
  elsif CONFIGURATION.rails_env == 'test'
    ActiveRecord::Base.establish_connection(
      adapter:  $CONFIGURATION.database_adapter, # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
      database: [@sqlite_root,'test.sqlite3'].join('/'),
    )
  else
    ActiveRecord::Base.establish_connection(
      :adapter  => $CONFIGURATION.database_adapter,
      :host     => $CONFIGURATION.database_host,
      :username => $CONFIGURATION.database_user,
      :password => $CONFIGURATION.database_password,
      :database => $CONFIGURATION.database_db
    )
  end

  def self.distributions
    return ['ubuntu', 'centos']
  end

  def self.packages
    modules = ['vim', 'nginx', 'apache', 'mocp', 'xclock', 'x11', 'cinnamon']
    return modules
  end
end
