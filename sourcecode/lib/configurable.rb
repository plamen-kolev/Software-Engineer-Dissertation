require 'active_record'
require_relative 'configurable'

module Helper
  class Configurable
    attr_reader :webroot

    # used to initialize db only once    
    @@db_init=0

    def initialize
      
      if @@db_init == 0

        @sqlite_root = "#{File.expand_path("#{File.dirname(__FILE__)}")}/../db/"

        if ENV['RAILS_ENV'] == 'development'
          ActiveRecord::Base.establish_connection(
            adapter:  ENV['DATABASE_ADAPTER'], # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
            database: [@sqlite_root,'development.sqlite3'].join('/'),
          )
        elsif ENV['RAILS_ENV'] == 'test'
          ActiveRecord::Base.establish_connection(
            adapter:  ENV['DATABASE_ADAPTER'], # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
            database: [@sqlite_root,'test.sqlite3'].join('/'),
          )
        else
          ActiveRecord::Base.establish_connection(
            :adapter  => ENV['DATABASE_ADAPTER'],
            :host     => ENV['DATABASE_HOST'],
            :username => ENV['DATABASE_USER'],
            :password => ENV['DATABASE_PASSWORD'],
            :database => ENV['DATABASE_DB']
          )
        end
        @@db_init = 1
      end

    end

  end

  


end

module DB
  class User < ActiveRecord::Base
  end

  class Machine < ActiveRecord::Base
  end
end

