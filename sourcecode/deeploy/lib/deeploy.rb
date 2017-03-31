require "deeploy/version"
require "vm"
require "user"
require 'figaro'

module Deeploy
  config_path = [File.expand_path("#{File.dirname(__FILE__)}"), "config/application.yml"].join('/')
  # puts config_path
  environment = ENV['deeploy_env']
  environment ||= "development"
  Figaro.application = Figaro::Application.new(environment: environment, path: config_path)
  Figaro.load
  $CONFIGURATION = Figaro.env

  # initialize environmental variables
  @sqlite_root = $CONFIGURATION.db_path
  # puts @sqlite_root

  if environment == 'development'
    ActiveRecord::Base.establish_connection(
      adapter:  $CONFIGURATION.database_adapter, # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
      database: [@sqlite_root,'development.sqlite3'].join('/'),
    )
  elsif environment == 'test'
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

  def self.network_interface
      %x[VBoxManage hostonlyif ipconfig vboxnet0 --ip 88.168.56.1]
      %x[VBoxManage hostonlyif ipconfig vboxnet1 --ip 87.168.56.1]
      sockips = Socket.getifaddrs.select{|ifaddr| ifaddr.addr.afamily == Socket::AF_INET && ifaddr.name == $CONFIGURATION.network_interface}. \
        map{|ifaddr| [ifaddr.addr, ifaddr.netmask].map &:ip_address}

      # grab netmask for the specified interface
      return sockips.first
      
  end

  def update_machines_alive(current_user)
    
  end


  def self.distributions
    return {
      ubuntu: 'ubuntu/xenial64', 
      centos: "bento/centos-7.2",
      debian: 'debian/jessie64'
    }
  end

  def self.packages
    # modules = ['vim', 'nginx', 'apache2', 'mysql-server', 'memcached']
    packages = {
        'vim': {
            'ubuntu': 'vim',
            'centos': 'vim-enhanced'
        },
        'nginx':{
            'ubuntu': 'nginx',
            'centos': 'nginx'
        },
        'apache2':{
            'ubuntu': 'apache2',
            'centos': 'apache2'
        },
        'mysql':{
            'ubuntu': 'mysql-server',
            'centos': 'mariadb-server'
        },
        'memcached':{
            'ubuntu': 'memcached',
            'centos': 'memcached'
        }
    }
    return packages
  end
end
