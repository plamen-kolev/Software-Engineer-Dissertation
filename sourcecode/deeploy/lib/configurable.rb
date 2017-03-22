require 'active_record'
require_relative 'configurable'
# require 'figaro'

module Deeploy
  class Configurable
    attr_reader :webroot

    # used to initialize db only once
    @@db_init=0

    def initialize()

    #   if @@db_init == 0
    #     # initialize environmental variables
    #     @sqlite_root = $CONFIGURATION.db_path ||= "#{File.expand_path("#{File.dirname(__FILE__)}")}/../db/"

    #     if $CONFIGURATION.rails_env == 'development'
    #       ActiveRecord::Base.establish_connection(
    #         adapter:  $CONFIGURATION.database_adapter, # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
    #         database: [@sqlite_root,'development.sqlite3'].join('/'),
    #       )
    #     elsif CONFIGURATION.rails_env == 'test'
    #       ActiveRecord::Base.establish_connection(
    #         adapter:  $CONFIGURATION.database_adapter, # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
    #         database: [@sqlite_root,'test.sqlite3'].join('/'),
    #       )
    #     else
    #       ActiveRecord::Base.establish_connection(
    #         :adapter  => $CONFIGURATION.database_adapter,
    #         :host     => $CONFIGURATION.database_host,
    #         :username => $CONFIGURATION.database_user,
    #         :password => $CONFIGURATION.database_password,
    #         :database => $CONFIGURATION.database_db
    #       )
    #     end
    #     @@db_init = 1
    #   end
    end
  end




end

module DB
  class User < ActiveRecord::Base
  end

  class Machine < ActiveRecord::Base
  end
end
