require 'deeploy/version'
require 'vm'
require 'user'
require 'figaro'
require 'ipaddr'

module Deeploy
  config_path = [File.expand_path(File.dirname(__FILE__)), 'config/application.yml'].join('/')
  # puts config_path
  environment = ENV['deeploy_env']
  environment ||= 'development'
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
      %x(VBoxManage hostonlyif ipconfig vboxnet0 --ip 88.168.56.1)
      %x(VBoxManage hostonlyif ipconfig vboxnet1 --ip 87.168.56.1)
      sockips = Socket.getifaddrs.select{|ifaddr| ifaddr.addr.afamily == Socket::AF_INET && ifaddr.name == $CONFIGURATION.network_interface}. \
          map{|ifaddr| [ifaddr.addr, ifaddr.netmask].map &:ip_address}

      # grab netmask for the specified interface
      return sockips.first
  end

  def self.distributions
    return {
      ubuntu: 'plamen-kolev/ubuntu',
      centos: 'plamen-kolev/centos',
      debian: 'plamen-kolev/debian'
    }
  end

  def self.slugify(string)
    #lowercase string
    string = string.downcase
    # remove whitespace, then replace space with dashes
    string = string.strip().tr(' ', '-')

    # get rid of all characters that are not ascii chars or dashes
    string = string.gsub(/[^\w-]/, '')
    if string.empty?
      raise ArgumentError, 'Expecting string output, slugification destroyed data'
    end
    return string
  end

  def self.valid_ip?(ip)
    host_ip, netmask = network_interface()
    host = IPAddr.new("#{host_ip}/24")
    return host.include?(IPAddr.new(ip))
  end

  def self.owner_exists!(owner)
    unless owner.class.to_s == 'Deeploy::User' or
        owner.class.to_s == 'User' or
        owner.class.to_s == 'DB::User'
      raise ArgumentError, 'Parameter owner must be of type DB::User or Deeploy::User'
    end
    return DB::User.find(owner.id)
  end

  def self.packages
    modules = ['vim', 'nginx', 'apache2', 'mysql', 'memcached']
    return modules
  end

  def self.alive(ip)
    begin
      Timeout::timeout(2) do
        begin
          TCPSocket.new(ip, 22).close
          return true
          # rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          # db_machine.alive = false
        end
      end
    rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      return false
    end
  end

  # def self.packages
  #   # modules = ['vim', 'nginx', 'apache2', 'mysql-server', 'memcached']
  #   packages = {
  #       'vim': {
  #           'ubuntu': 'vim',
  #           'centos': 'vim-enhanced'
  #       },
  #       'nginx':{
  #           'ubuntu': 'nginx',
  #           'centos': 'nginx'
  #       },
  #       'apache2':{
  #           'ubuntu': 'apache2',
  #           'centos': 'apache2'
  #       },
  #       'mysql':{
  #           'ubuntu': 'mysql-server',
  #           'centos': 'mariadb-server'
  #       },
  #       'memcached':{
  #           'ubuntu': 'memcached',
  #           'centos': 'memcached'
  #       }
  #   }
  #   return packages
  # end
end
