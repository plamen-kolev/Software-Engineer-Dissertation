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
  end

  def test_validation_missing_title
    exception = assert_raises ArgumentError do
      Deeploy::VM.get(owner: @user)
    end
    assert_equal('pass argument symbol :title', exception.message)
  end

  def test_validation_missing_owner
    exception = assert_raises ArgumentError do
      Deeploy::VM.get(title: @title)
    end
    assert_equal('pass argument symbol :owner', exception.message)
  end

  def test_validation_invalid_user
    exception = assert_raises ActiveRecord::RecordNotFound do
      result = Deeploy::VM.get(title: @title, owner: DB::User.new)
    end

    assert_equal("Couldn't find DB::User with 'id'=", exception.message)
  end

  def test_validation_nonexisting_title
    result = Deeploy::VM.get(title: 'made-up-dont-exist', owner: @user)
    assert(!result, "Expecting function to return false, returned #{result.inspect} instead")
  end

  def test_get_successful
    # cleanup first
    result = Deeploy::VM.get(title: @title, owner: @user)
    if result
      result.destroy()
    end

    vm = Deeploy::VM.new(
      owner: @user,
      distribution: @distribution,
      title: @title,
      vm_user: @vm_user
    )
    vm.build(true)

    result = Deeploy::VM.get(title: @title, owner: @user)
    assert(result, "Expecting function to return VM class, returned #{result.inspect} instead")
  end
end