ENV['deeploy_env'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'deeploy'

class TestDeeployStaticMethods < Minitest::Test
  def setup
  end

  def test_string_slugification
    result = Deeploy::slugify('I am a І	К	Л	М	Н	Ѯ	slug with cyrilic chars @//')
    assert_match (/i-am-a-slug-with-cyrilic-chars/), result
  end

  def test_string_slugificcation_invalid_caracters

    exception = assert_raises ArgumentError do
      Deeploy::slugify('@@@@@@@@@@@@@@@')
    end
    assert_equal('Expecting string output, slugification destroyed data', exception.message)
  end
end