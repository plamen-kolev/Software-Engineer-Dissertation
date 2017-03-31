require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'deeploy'
require 'net/ssh'
require 'figaro'
require 'timeout'
require 'socket'

@user = ::DB::User.find(1)
@distribution = "ubuntu"
@vm_user = "testuser"
@title = "test_machine"
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