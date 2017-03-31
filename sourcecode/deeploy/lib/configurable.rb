require 'active_record'

module Deeploy
  class Configurable
    attr_reader :webroot

    # used to initialize db only once
    @@db_init=0

    def initialize()
    end
  end

end

module DB
  class User < ActiveRecord::Base
  end

  class Machine < ActiveRecord::Base
  end
end
