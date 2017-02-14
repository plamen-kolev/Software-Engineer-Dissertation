require 'active_record'

module Helper
  class Configurable
    attr_reader :webroot, :user, :password, :auth_user,:auth_password, :auth_token, :machines, :vm_name
    
    def initialize
      @webroot = [Dir.pwd, 'deepsky'].join('/')
      @user
      @password
      @auth_user
      @auth_password
      @auth_token
      @machines
      @distribution
      @vm_name


      @distributions = {
        'ubuntu' => 'ubuntu/xenial64',
        'debian' => 'debian/jessie64'
      }

    end

    def set_distribution(distro)
      @distribution = @distributions[distro]
    end

    def valid_args!(args={}, options)
      errors=0
      # first, check if auth args are passed
      
      if !((options.auth_user and options.auth_password) or options.auth_token)
        $stderr.puts "Missing authentication: \nUse --auth_user username --auth_password password\nOr --auth_token token,\n"
        errors+=1
      end
      
      args.each do |key, value|
        if value.to_s.empty?
          $stderr.puts "Missing argument: --#{key},\n"
          errors+=1
        else
          self.instance_variable_set("@#{key}", value)
        end
      end

      if errors > 0
        $stderr.puts "Use --help for more information"
        exit 1 
      end
    end

    def is_authenticated()
      return @user.to_s.empty?
    end

    def fetch_machines
      @machines = Helper::Machine.where(user_id: @user.id)
    end

    def get_machine(name)
      if ! @machines
        self.fetch_machines
      end
      @machines.each do | machine |
        return machine if machine.title == name
      end
      return
    end

    def authenticate!(options)

      # using username password requires validation
      if options.auth_user and options.auth_password
        db_user = User.where(email: options.auth_user).take
        if (not db_user) or db_user.email != options.auth_user
          $stderr.puts "Username or password incorrect"
          exit 1
        end

        # validate password match

        bcrypt   = ::BCrypt::Password.new(db_user.encrypted_password)
        password = ::BCrypt::Engine.hash_secret(options.auth_password, bcrypt.salt)

        unless password != db_user.encrypted_password
          @user = db_user
          return 1
        end
      else
        db_user = User.where(token: options.auth_token).take
        @user = db_user if db_user
        return 1
      end

      $stderr.puts "Username or password incorrect"
      exit 1
    end

  end

  class Person < Configurable

    def initialize(env)
      super()
      ActiveRecord::Base.establish_connection(
        adapter:  env['DATABASE_ADAPTER'], # or 'postgresql' or 'sqlite3' or 'oracle_enhanced'
        database: [@webroot,'db','development.sqlite3'].join('/'),
      )
      
    end
  end

  class User < ActiveRecord::Base
  end

  class Machine < ActiveRecord::Base
  end
end

