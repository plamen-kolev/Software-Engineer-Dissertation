require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'deeploy'
require 'net/ssh'
require 'figaro'
require 'timeout'
require 'socket'

class DeeployTest < Minitest::Test

  def setup
    @user = ::DB::User.find(1)
    @distribution = "ubuntu"
    @vm_user = "testuser"
    @title = "test_machine"

#    if ::DB::Machine.where(title: @title).take
#      m = Deeploy::VM.get(title: @title, owner: @user)
#      m.destroy()
#    end

  end

  # def teardown()
  #   if @machine
  #     @machine.destroy(true)
  #   end
  # end

  # # build a machine and execute commands on it
  # def test_deploy_machine
  #   @machine = Deeploy::VM.new(
  #     distribution: @distribution,
  #     title: @title,
  #     owner: @user,
  #     vm_user: @vm_user,
  #   )
  #   @machine.build()
  #   ssh_commands(['date'])
  # end

  # def test_deeploy_ports_and_packages
  #   packages = %w(nginx vim mysql memcached)
  #   ports = [80, 3306, 11211]
  #   @machine = Deeploy::VM.new(
  #     distribution: @distribution,
  #     title: @title,
  #     owner: @user,
  #     vm_user: @vm_user,
  #     opts: {
  #       packages: packages,
  #       ports: ports
  #     }
  #   )
  #
  #   @machine.build()
  #   all_packages_and_ports(ports, packages)
  # end

  def test_centos_ports_and_software

    packages = %w(nginx vim mysql memcached)
    ports = [80, 3306, 11211]
    @machine = Deeploy::VM.new(
      distribution: 'centos',
      title: @title,
      owner: @user,
      vm_user: @vm_user,
      opts: {
          packages: packages,
          ports: ports
      }
    )

    @machine.build()
    all_packages_and_ports(ports, packages)
  end

  def test_debian_ports_and_software
  end

  def test_invalid_user
  end

  def test_invalid_packages
  end

  def test_invalid_distribution
  end

  def all_packages_and_ports(ports, packages)
    session = ::Net::SSH.start(
      @machine.ip,
      @machine.vm_user,
      keys: [[@machine.root, '.ssh', "#{@machine.title}.pem"].join('/')],
      paranoid: Net::SSH::Verifiers::Null.new
    )

    # nginx status running must give exit code 0
    result = session.exec!('sudo service nginx status | grep running ; echo $?')
    assert_equal result.split(/\n/)[-1].to_i, 0

    # nginx status running must give exit code 0
    result = session.exec!('sudo service mysql status | grep running ; echo $?')
    assert_equal result.split(/\n/)[-1].to_i, 0

    result = session.exec!('sudo service memcached status | grep running ; echo $?')
    assert_equal result.split(/\n/)[-1].to_i, 0

    # test vim installed
    result = session.exec!('vim --version | grep "Vi IMproved" ; echo $?')
    assert_equal result.split(/\n/)[-1].to_i, 0
    ports.each do |p|

      begin
        Timeout::timeout(2) do
          begin
            TCPSocket.new(@machine.ip, p).close
            assert(true, "Port #{p} open")
            # rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            # db_machine.alive = false
          end
        end
      rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        assert(false, "Port #{p} close")
      end
    end
  end

  def ssh_commands(command_array)
    session = ::Net::SSH.start( 
        @machine.ip,
        @machine.vm_user,
        :keys => [ [@machine.root, '.ssh', "#{@machine.title}.pem"].join('/') ],
        :paranoid => Net::SSH::Verifiers::Null.new
    ) 
    command_array.each do |command|
      result = session.exec!(command)
      assert_equal result.class, Net::SSH::Connection::Session::StringWithExitstatus
    end

  end

end
