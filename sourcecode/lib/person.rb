require 'active_record'
require 'bcrypt'
require_relative 'configurable'

module Helper

  class Person < Configurable
    attr_reader :user, :password, :auth_user,:auth_password, :auth_token, :machines, :vm_name
    def initialize(env)
      super()
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
        if (not db_user) or (db_user.email != options.auth_user)
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
        if db_user
          @user = db_user 
          return 1
        else
          $stderr.puts "Invalid token"
          exit 1
        end
        
      end

      $stderr.puts "Username or password incorrect"
      exit 1
    end

  end

end

