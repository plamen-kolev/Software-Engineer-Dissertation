ENV['deeploy_env'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'deeploy'
require 'net/ssh'
require 'timeout'

class MachineBuildTest < Minitest::Test
  def setup
    @title = 'unique_machine'
    @user = DB::User.find(1)
    @distribution = 'ubuntu'
    @vm_user = 'mainuser'
    @db_machine = DB::Machine.first
    @packages = %w(nginx vim mysql memcached)
    @ports = [80, 3306, 11211]
    machine = Deeploy::VM.get(title: @title, owner: @user)
    machine.destroy() if machine
  end

  def test_build_ubuntu_vm
    # clean it up if it exists
    m = Deeploy::VM.get(title: @title, owner: @user)
    if m
      m.destroy()
    end

    @machine = Deeploy::VM.new(
      distribution: 'ubuntu',
      title: @title,
      owner: @user,
      vm_user: @vm_user,
      opts: {
          packages: @packages,
          ports: @ports
      }
    )

    # give machine 3 minuutes to complete
    Timeout::timeout(180) do
      @machine.build()
    end
    session = get_ssh_session(@machine)
    check_running('sudo service nginx status | grep running ; echo $?', session)
    check_running('sudo service mysql status | grep running ; echo $?', session)
    check_running('sudo service memcached status | grep running ; echo $?', session)
    check_running('vim --version | grep "Vi IMproved" ; echo $?', session)
    check_open_ports(@machine, @ports)
  end

  def test_build_centos_vm

    # clean it up if it exists
    m = Deeploy::VM.get(title: @title, owner: @user)
    if m
      m.destroy()
    end

    @machine = Deeploy::VM.new(
      distribution: 'centos',
      title: @title,
      owner: @user,
      vm_user: @vm_user,
      opts: {
        packages: @packages,
        ports: @ports
      }
    )

    # give machine 6 minuutes to complete
    Timeout::timeout(360) do
      @machine.build()
    end
    session = get_ssh_session(@machine)
    check_running('sudo service nginx status | grep running ; echo $?', session)
    check_running('sudo service mysql status | grep running ; echo $?', session)
    check_running('sudo service memcached status | grep running ; echo $?', session)
    check_running('vim --version | grep "Vi IMproved" ; echo $?', session)
    check_open_ports(@machine, @ports)
  end

  def get_ssh_session(machine)
    return Net::SSH.start(
      machine.ip,
      machine.vm_user,
      keys: [[machine.root, '.ssh', "#{machine.title}.pem"].join('/')],
      paranoid: Net::SSH::Verifiers::Null.new
    )
  end

  def check_running(command, session)
    result = session.exec!(command)
    assert_equal result.split(/\n/)[-1].to_i, 0
  end

  def check_open_ports(machine, ports)
    ports.each do |p|
      begin
        Timeout::timeout(2) do
          begin
            TCPSocket.new(machine.ip, p).close
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
end