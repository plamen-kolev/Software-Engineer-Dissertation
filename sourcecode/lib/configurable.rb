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

    # def valid_args!(args={}, options)
    #   errors=0
    #   # first, check if auth args are passed
      
    #   if !((options.auth_user and options.auth_password) or options.auth_token)
    #     $stderr.puts "Missing authentication: \nUse --auth_user username --auth_password password\nOr --auth_token token,\n"
    #     errors+=1
    #   end
      
    #   args.each do |key, value|
    #     if value.to_s.empty?
    #       $stderr.puts "Missing argument: --#{key},\n"
    #       errors+=1
    #     else
    #       self.instance_variable_set("@#{key}", value)
    #     end
    #   end

    #   if errors > 0
    #     $stderr.puts "Use --help for more information"
    #     exit 1 
    #   end
    # end

  end

  

  class Machine < ActiveRecord::Base
  end
end

module DB
  class User < ActiveRecord::Base
  end
end

