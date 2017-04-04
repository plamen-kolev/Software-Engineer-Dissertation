require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'deeploy'

class MachineCreationTest < Minitest::Test
  def setup
    @user = DB::User.find(1)
    @distribution = 'ubuntu'
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
end