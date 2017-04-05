ENV['deeploy_env'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'deeploy'


class MachineCreationTest < Minitest::Test
  def setup
    @unique_machine_name = 'unique_machine'
    @user = DB::User.find(1)
    @distribution = 'ubuntu'
    @db_machine = DB::Machine.first
    machine = Deeploy::VM.get(title: @unique_machine_name, owner: @user)
    machine.destroy() if machine
  end

  def test_missing_argument_owner
    exception = assert_raises ArgumentError do
      Deeploy::VM.new(
        distribution: 'ubuntu',
        vm_user: 'user',
        title: 'title'
      )
    end
    assert_equal('pass argument symbol :owner', exception.message)
  end

  def test_invalid_owner
    exception = assert_raises ActiveRecord::RecordNotFound do
      Deeploy::VM.new(
        owner: DB::User.new,
        title: 'foo',
        distribution: 'ubuntu',
        vm_user: 'vmuser'
      )
    end
  end

  def test_missing_argument_distribution
    exception = assert_raises ArgumentError do
      Deeploy::VM.new(
        owner: @user,
        title: 'some title',
        vm_user: 'somevmuser',
      )
    end
    assert_equal('pass argument symbol :distribution', exception.message)
  end

  def test_missing_argument_title
    exception = assert_raises ArgumentError do
      Deeploy::VM.new(
        owner: @user,
        distribution: @distribution,
        vm_user: 'somevmuser'
      )
    end
    assert_equal('pass argument symbol :title', exception.message)
  end

  def test_missing_argument_vm_user
    exception = assert_raises ArgumentError do
      Deeploy::VM.new(
        owner: @user,
        distribution: @distribution,
        title: 'hello world'
      )
    end
    assert_equal('pass argument symbol :vm_user', exception.message)
  end

  def test_vm_user_is_htmlsafe
    vm = Deeploy::VM.new(
      title: 'sometitle',
      distribution: 'ubuntu',
      vm_user: 'some title that needs to be tokenised\@І	К	Л	М	Н	Ѯ	',
      owner: @user
    )
    assert_match 'some-title-that-needs-to-be-tokenised', vm.vm_user
  end

  def test_vm_title_is_htmlsafe

    vm = Deeploy::VM.new(
      vm_user: 'someuser',
      distribution: 'ubuntu',
      title: 'some title that needs to be tokenised\@І	К	Л	М	Н	Ѯ	',
      owner: @user
    )
    assert_match 'some-title-that-needs-to-be-tokenised', vm.title

  end

  def test_invalid_distribution
    exception = assert_raises ArgumentError do
      Deeploy::VM.new(
        owner: @user,
        distribution: 'invalid',
        title: 'some title',
        vm_user: 'somevmuser',
      )
    end
    assert_match '\'invalid\' is not a recognized option', exception.message
  end

  def create_existing_vm_throws_error
    exception = assert_raises ActiveRecord::RecordNotUnique do
      Deeploy::VM.new(
        owner: @user,
        distribution: 'ubuntu',
        title: @db_machine.title,
        vm_user: 'somevmuser'
      )
    end
    assert_match /This machine already exists/, exception.message
  end

  def test_create_valid_vm_ubuntu
    vm_user = 'somevmuser'
    vm = Deeploy::VM.new(
      owner: @user,
      distribution: 'ubuntu',
      title: @unique_machine_name,
      vm_user: vm_user
    )
    vm.build(true)
    # test puppet config exists
    puppet_path = [vm.root, 'manifests', 'default.pp'].join('/')
    assert(false, "Expecting file #{puppet_path} to exist") unless File.exist?(puppet_path)

    # test machine has valid ip
    unless Deeploy::valid_ip?(vm.ip)
      assert(false, "Expecting vm #{vm.title} to have valid ip, got #{vm.ip} instead")
    end

    found_puppet_name = false
    # test user name is in puppet config
    File.open puppet_path do |file|
      file.find { |line|
        line =~ /User { \"#{vm_user}\":/
        found_puppet_name = true
      }
    end
    assert(found_puppet_name, "Expecting to find name #{vm_user} in file #{puppet_path}")

    # test ubuntu related commands are there
    found_apt_get = false
    File.open puppet_path do |file|
      file.find { |line|
        line =~ /apt-get update/
        found_apt_get = true
      }
    end
    assert(found_apt_get, "Expecting to find line apt-get update in file #{puppet_path}, but was unable")

    # check puppet syntax error
    puppet_validation_command = "puppet parser validate #{puppet_path}"

    begin
      system(puppet_validation_command)
    rescue
      assert(false, "Puppet validation command failed for #{vm.title}, file at #{puppet_path}")
    end

  end
end