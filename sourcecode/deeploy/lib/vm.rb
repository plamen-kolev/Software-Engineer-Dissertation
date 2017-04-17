require_relative 'user'
require_relative 'confmanager'
require 'ipaddr'
# require 'figaro'

module Deeploy
  class VM < Configurable
    attr_accessor :owner, :distribution, :root, :manifest, :vm_user, :ip, :title, :configuration, :id, :disk, :ram, :packages, :ports, :pem
    # @owner
    # @title
    # @root
    # @disk
    # @ram
    # @packages
    # @ports

    def initialize(args = {})
      @disk = 1; @ram = 1; @packages = []; @ports = []; @fetch = false
      # check for required parameters
      raise ArgumentError, 'pass argument symbol :owner' unless args[:owner]
      raise ArgumentError, 'pass argument symbol :distribution' unless args[:distribution]
      raise ArgumentError, 'pass argument symbol :title' unless args[:title]
      raise ArgumentError, 'pass argument symbol :vm_user' unless args[:vm_user]

      @userspace = 'userspace'
      @userspace = 'test_userspace' if $CONFIGURATION.deeploy_env == 'test'

      opts = args[:opts]

      if opts
        @disk = opts[:disk] if opts[:disk]
        @id = opts[:id].to_i if opts[:id]
        @ip = opts[:ip] if opts[:ip]
        @ram = opts[:ram] if opts[:ram]
        @fetch = opts[:fetch] if opts[:fetch]

        if opts[:packages]

          opts[:packages].each do |package|
            @packages.push(package.strip)
          end
          # now filter out the allowed packages
          # set intersection
          @packages &= Deeploy::packages
        end

        @ports = opts[:ports] if opts[:ports]
      end

      return false unless Deeploy::owner_exists!(args[:owner])
      @owner = args[:owner]

      # allowed list of distributions
      distributions = Deeploy::distributions()

      # test to see if distribution lookup will work, otherwise error out
      if distributions[args[:distribution].to_sym]
        @distribution = args[:distribution]
      else
        raise ArgumentError, "Distribution '#{args[:distribution]}' is not a recognized option,\nOptions are: #{distributions.keys}, aborting"
      end

      @title ||= Deeploy::slugify(args[:title])
      unless @fetch
        if DB::Machine.where(title: @title).count > 0
          raise ActiveRecord::RecordNotUnique, "Machine #{@title} already exists !\nTry using VM.get instead of VM.new !"
        end
      end
      @ip ||= self.generate_ip()

      vm_dir = $CONFIGURATION.machine_path
      # set the folder path (absolute path on the os)
      @root = [vm_dir, @userspace, @owner.email, @title].join('/')
      @manifest = @root + '/manifests'

      @vm_user = Deeploy::slugify(args[:vm_user])
      @configuration = Deeploy::Confmanager.new(self)
      return self
    end

    def alive?
      db_machine = DB::Machine.where(title: self.title).take

      begin
        Timeout::timeout(2) do
          begin
            TCPSocket.new(@ip, 22).close
            db_machine.alive = true
            db_machine.save()
            return true
            # rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            # db_machine.alive = false
          end
        end
      rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        db_machine.alive = false

      end

      db_machine.save
      return false
      # end trying here
    end

    # takes machine name and owner object
    def self.get(args = {})
      raise ArgumentError, 'pass argument symbol :owner' unless args[:owner]
      raise ArgumentError, 'pass argument symbol :title' unless args[:title]
      return false unless Deeploy::owner_exists!(args[:owner])
      db_machine = DB::Machine.where(user_id: args[:owner].id, title: args[:title]).take
      return false unless db_machine

      vm_dir = $CONFIGURATION.machine_path

      @userspace = 'userspace'
      @userspace = 'test_userspace' if $CONFIGURATION.deeploy_env == 'test'

      machine = new(
        title: db_machine.title,
        distribution: db_machine.distribution,
        root: [vm_dir, @userspace, args[:owner].email, db_machine.title].join('/'),
        owner: DB::User.find(db_machine.user_id),
        vm_user: db_machine.vm_user,
        opts: {
          pem: db_machine.pem,
          id: db_machine.id,
          ip: db_machine.ip,
          ports: db_machine.ports,
          packages: db_machine.packages,
          ram: db_machine.ram,
          fetch: true
        }
      )

      if db_machine.user_id != machine.owner.id
        raise AuthorizationException, "The user #{machine.owner.email} does not own the virtual machine #{db_machine.title}"
      end

      return machine
    end

    # keep machine folder for debugging
    def destroy(keep_folders = false)
      if Dir.exist?(@root)
        Dir.chdir(@root) do
          system('vagrant destroy -f')
        end
        FileUtils.rm_rf(@root) unless keep_folders
      end
      vm = DB::Machine.find(@id)
      vm.destroy if vm
    end

    def down()
      if Dir.exist?(@root)
        Dir.chdir(@root) do
          system('vagrant halt')
        end
      end
    end

    def up
      if Dir.exist?(@root)
        Dir.chdir(@root) do
          system('vagrant up')
        end
      else
        raise Exception, "#{root} was empty"
      end
    end

    def _get_or_create_machine()
      machine = DB::Machine.where(title: @title)
      # create machine is not running as part of backend
      if machine.first
        machine = machine.first
      else
        machine = DB::Machine.new(
          title: @title,
          user_id: @owner.id,
          deployed: false,
          distribution: @distribution,
          vm_user: @vm_user
        )
      end
      return machine
    end

    def build(dryrun = false)
      puts "Building VM '#{@title}'.\nPlease wait "
      FileUtils.mkdir_p(@manifest)
      # @configuration.writeall(shell: "#{@manifest}/setup.sh", vagrant: "#{@root}/Vagrantfile", puppet: "#{@manifest}/default.pp")
      @configuration.writeall()

      machine = self._get_or_create_machine

      machine.ip = @ip
      machine.pem = File.open(
        [@root, '.ssh', "#{@title}.pem"].join('/'), 'r'
      ).read
      machine.save

      self.id = machine.id
      result = false

      if dryrun
        result = true
      else
        Dir.chdir(@root) do
          # sub shell process and wait for it to exit
          result = self.wait_on_build(machine)
        end
      end

      if result
        self.success()
        machine.deployed = true
        machine.save
        return true
      else
        self.destroy(true)
        raise Exception, "Errors were encountered, cleaning up: #{$?.inspect}"
      end
    end

    def wait_on_build(machine)

      stages = [
        'default: Configuring and enabling network interfaces',
        'Running provisioner: puppet',
        'Exec\[update_dependencies\].*executed successfully',
        'default: Notice: Finished catalog run in'
      ]
      stages_length = stages.length - 1
      current_stage = 0
      # put command in background
      pid = spawn("vagrant up &> #{@root}/vagrant.log")
      Process.detach(pid)
      counter = 0
      # wait for process to finish, also display build process in the meanwhile
      while counter < 600
        begin
          result = Process.kill 0, pid
        rescue Errno::ESRCH
          puts 'Build successfull !'
          machine.build_stage = stages_length
          machine.save()
          return true
        end

        # now try to find key moments in the deployment of a machine
        begin
          break if stages.empty?
          File.open([@root, 'vagrant.log'].join('/'), 'r') do |f|
            stage = stages[0]
            f.each_line do |line|
              # check if the next stage is in the file
              if line =~ %r{#{stage}}
                current_stage += 1
                machine.build_stage = current_stage
                machine.save()
                puts "Status: #{stage}"
                stages.shift()
              end
            end
          end
        rescue Errno::ENOENT
        end

        sleep 10
        counter += 10
      end

    end

    def success
      $stdout.puts <<-HERE
#{'=' * 50}
    Operation successfull:
  #{'-' * 50}
    VM NAME:\t\t|\t#{@title}
    IP:\t\t\t|\t#{@ip}
    User:\t\t|\t#{@vm_user}
#{'-' * 50}
    Distribution:\t|\t#{@distribution}
#{'=' * 50}
HERE
    end

    def generate_ip
      # grab netmask for the specified interface
      host_ip, netmask = Deeploy::network_interface()
      if !host_ip || !netmask
        $stderr.puts("Interface '#{$CONFIGURATION.network_interface}' did not return an ip or mask for the host !\n.") # Recreating virtual network.")
        raise "Interface '#{$CONFIGURATION.network_interface}' did not return an ip or mask for the host !\n."
      end

      # map to string flatters the object array to string array
      range = IPAddr.new(
        [host_ip, netmask].join('/')
      ).to_range.map(&:to_s)

      # blacklist broadcast ips ranges based on the host's ip, e.g. if the host has ip of 12.200.30.20, 12.200.30.0 and 12.200.30.255 will be blacklisted
      tokenised_ip = host_ip.split('.')
      tokenised_ip.pop
      tokenised_ip = tokenised_ip.join('.')

      blacklisted_ips = DB::Machine.all.collect{ |obj| obj.ip }
      blacklisted_ips += ["#{tokenised_ip}.0", "#{tokenised_ip}.255", host_ip]

      # array difference of available ips and taken ips
      available_ips = range - blacklisted_ips

      @ip = available_ips[-1]
      if Deeploy::valid_ip?(@ip)
        return @ip
      end
      raise IPAddr::InvalidAddressError, "Address #{ip} does not belong to the host range #{host_ip} or is invalid"
    end
  end
end
