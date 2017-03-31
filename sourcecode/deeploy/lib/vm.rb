require_relative 'user'
require_relative 'confmanager'
require 'ipaddr'
# require 'figaro'

module Deeploy
  class VM < Configurable
    attr_accessor :owner, :distribution, :root, :manifest, :vm_user, :ip, :title, :configuration, :id, :disk, :ram, :packages, :ports, :pem
    @owner
    @title
    @root

    def initialize(args = {})
      opts = args[:opts]

      if opts
        @disk = disk if disk = opts[:disk]
        @id = id.to_i if id = opts[:id]
        @ip = ip if ip = opts[:ip]
        @ram = ram if ram = opts[:ram]

        if packages = opts[:packages]
          @packages = packages
          @packages.each do |package|
            package = package.strip
          end
          # now filter out the allowed packages
          @packages = @packages & Deeploy::packages
        end

        if opts[:ports]
          @ports = opts[:ports]
        end

      end

      @disk ||= 1; @ram ||= 1; @packages ||= []; @ports ||= []

      # open ports

      return false unless self._verify_owner(args[:owner])

      @owner = args[:owner]

      # allowed list of distros
      distributions = Deeploy::distributions()

      # test to see if distribution lookup will work, otherwise error out
      if distributions[args[:distribution].to_sym]
        @distribution = args[:distribution]
      else
        $stderr.puts "Distribution '#{args[:distribution]}' is not a recognized option,\nOptions are: #{distributions.keys}, aborting"
        # exit 1
        raise ArgumentError
      end

      # human friendly virtual machine name
      # instance.title = "#{args[:title]}_#{$CONFIGURATION.rails_env}"
      @title ||= args[:title]
      @ip ||= self.generate_ip()

      vm_dir = $CONFIGURATION.machine_path
      # set the folder path (absolute path on the os)
      @root = [vm_dir, 'userspace', @owner.email, @title].join('/')
      @manifest = @root + '/manifests'

      @vm_user = args[:vm_user]
      @configuration = Deeploy::Confmanager.new(self)
      return self

    end

    def alive
      db_machine = DB::Machine.where(title: self.title).take

      begin
        Timeout::timeout(2) do
          begin
            TCPSocket.new(@ip, 22).close
            db_machine.alive = true
            # rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            # db_machine.alive = false
          end
        end
      rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        db_machine.alive = false
      end

      db_machine.save

      # end trying here
    end

    # takes machine name and owner object
    def self.get(args = {})

      db_machine = DB::Machine.where(user_id: args[:owner].id, title: args[:title]).take
      unless db_machine
        $stderr.puts("Unable to find machine '#{args[:title]}' for user '#{args[:owner].email}'")
        return false
      end
      vm_dir = $CONFIGURATION.machine_path

      machine = new(
        title: db_machine.title,
        distribution: db_machine.distribution,
        root: [vm_dir, 'userspace', args[:owner].email, db_machine.title].join('/'),
        owner: DB::User.find(db_machine.user_id),
        vm_user: db_machine.vm_user,
        opts: {
          pem: db_machine.pem,
          id: db_machine.id,
          ip: db_machine.ip,
          ports: db_machine.ports,
          packages: db_machine.packages,
          ram: db_machine.ram
        }
      )

      machine._verify_owner(args[:owner])
      if db_machine.user_id != machine.owner.id
        $stderr.puts('The user does not own the virtual machine')
        raise AuthorizationException
      end

      return machine
    end

    def _verify_owner(owner)
      if owner.class.to_s == 'Deeploy::User' or owner.class.to_s == 'User' or owner.class.to_s == 'DB::User'
        user = DB::User.find(owner.id)
        return user
      else
        raise ArgumentError 'Parameter owner must be of type DB::User or Deeploy::User'
      end

    end

    # keep machine folder for debugging
    def destroy(keep_folders = false)
      if Dir.exists?(@root)
        Dir.chdir(@root) do
          result = system(
            'vagrant destroy -f'
          )
        end

        FileUtils.rm_rf(@root) unless keep_folders

      end

      vm = DB::Machine.find(@id)
      vm.destroy if vm
    end

    def down()
      if Dir.exists?(@root)
        Dir.chdir(@root) do
          result = system(
            'vagrant halt'
          )
        end
      end
    end

    def up
      if Dir.exists?(@root)
        Dir.chdir(@root) do
          result = system(
            'vagrant up'
          )
        end
      else
        raise Exception, "#{root} was empty"
      end
    end
    
    def build
      FileUtils.mkdir_p(@manifest)
      # @configuration.writeall(shell: "#{@manifest}/setup.sh", vagrant: "#{@root}/Vagrantfile", puppet: "#{@manifest}/default.pp")
      @configuration.writeall()

      machine = DB::Machine.where(title: @title)
      # create machine is not running as part of backend
      if machine.first
        machine = machine.first
      else
        machine = DB::Machine.new(title: @title, user_id: @owner.id, deployed: false, distribution: @distribution, vm_user: @vm_user)
      end

      machine.ip = @ip
      machine.pem = File.open(
          [@root, '.ssh', "#{@title}.pem"].join('/'), 'r'
      ).read
      machine.save

      self.id = machine.id
      result = false

      Dir.chdir(@root) do
        result = system("vagrant up &> #{@root}/vagrant.log")
      end

      if result
        self.success()
        machine.deployed = true
        machine.save
        return true
      else
        $stderr.puts("Errors were encountered, cleaning up: #{$?.inspect}")
        self.destroy(true)
        return false
      end
    end

    def up
      Dir.chdir(@root) do
        system('vagrant up')
      end
    end

    def in_db?
      return @owner.get_machine(@title)
    end

    def in_dir?
      if File.directory?(@root)
        return true
      end
      return false
    end

    def success()
      $stdout.puts <<-HERE
#{"="*50}
    Operation successfull:
  #{"-"*50}
    VM NAME:\t\t|\t#{@title}
    IP:\t\t\t|\t#{@ip}
    User:\t\t|\t#{@vm_user}
#{"-"*50}
    Distribution:\t|\t#{@distribution}
#{"="*50}
HERE
    end

    def generate_ip()

      # grab netmask for the specified interface
      host_ip, netmask = Deeploy::network_interface()
      if not host_ip or not netmask
        $stderr.puts("Interface '#{$CONFIGURATION.network_interface}' did not return an ip or mask for the host !\n.") # Recreating virtual network.")
        raise "Interface '#{$CONFIGURATION.network_interface}' did not return an ip or mask for the host !\n."
      end

      # map to string flatters the object array to strign array
      range = IPAddr.new(
          [host_ip, netmask].join('/')
      ).to_range.map(&:to_s)

      # blacklist broadcast ips ranges based on the host's ip, e.g. if the host has ip of 12.200.30.20, 12.200.30.0 and 12.200.30.255 will be blacklisted
      tokenized_ip = host_ip.split('.')
      tokenized_ip.pop
      tokenized_ip = tokenized_ip.join('.')

      blacklisted_ips = DB::Machine.all.collect{|obj| obj.ip}
      blacklisted_ips += ["#{tokenized_ip}.0", "#{tokenized_ip}.255", host_ip]

      # array difference of available ips and taken ips
      available_ips = range - blacklisted_ips

      @ip = available_ips[-1]
    end
  end
end
