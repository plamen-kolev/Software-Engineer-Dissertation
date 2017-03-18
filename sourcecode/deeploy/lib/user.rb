require 'active_record'
require 'bcrypt'
require_relative 'configurable'

module Deeploy
  
  class User < Configurable
    attr_reader :id, :email, :token

    def initialize(args = {email: nil, token:nil})
      super()

      @email = args[:email] if args[:email]
      @id = args[:id]
      @token = args[:token] if args[:token]
    end

    def is_authenticated()
      return @user.to_s.empty?
    end

    def fetch_machines
      @machines = DB::Machine.where(user_id: @id)
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

    def self.authenticate(options = {})
      # using username password requires validation
      if options[:email] and options[:password]
        db_user = DB::User.where(email: options[:email]).take
        if (not db_user) or (db_user.email != options[:email])
          $stderr.puts "Username or password incorrect"
          return false
        end

        # validate password match

        bcrypt   = ::BCrypt::Password.new(db_user.encrypted_password)
        password = ::BCrypt::Engine.hash_secret(options.password, bcrypt.salt)

        unless password != db_user.encrypted_password
          @user = db_user
          return self.new(id: @user.id, email: @user.email, token: @user.token)
        end
      
      # otherwise fetch by token
      else
        db_user = DB::User.where(token: options[:token]).take

        if db_user
          @user = db_user
          return self.new(id: @user.id, email: @user.email, token: @user.token)
        else
          $stderr.puts "Invalid token"
          return false
        end
        
      end

      $stderr.puts "Username or password incorrect"
      exit 1
    end

  end

end

