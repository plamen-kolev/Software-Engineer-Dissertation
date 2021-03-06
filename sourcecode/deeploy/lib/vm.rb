require_relative 'user'
require_relative 'confmanager'
require 'open3'
require 'ipaddr'
# require 'figaro'

module Deeploy
  class VM < Configurable
    attr_accessor :owner, :distribution, :root, :manifest, :vm_user, :ip, :title, :configuration, :id, :disk, :ram, :packages, :ports, :pem, :build_status

    def initialize(args = {})
      # stages is used when reporting current build status
      @stages = [
        {'default: Configuring and enabling network interfaces' => 'Configuring network interfaces'},
        {'Running provisioner: puppet' => 'Setting up rules and software'},
        {'Exec\[update_dependencies\].*executed successfully' => 'Packages Repository updated'},
        {'default: Notice: Finished catalog run in' => 'Setting up machine completed'}
      ]

      @disk = 1; @ram = 1024; @packages = []; @ports = []; @fetch = false; @build_stage = 0; @build_status = 'pending'
      # check for required parameters
      raise ArgumentError, 'pass argument symbol :owner' unless args[:owner]
      raise ArgumentError, 'pass argument symbol :distribution' unless args[:distribution]
      raise ArgumentError, 'pass argument symbol :title' unless args[:title]
      raise ArgumentError, 'pass argument symbol :vm_user' unless args[:vm_user]

      @userspace = 'userspace'
      @userspace = 'test_userspace' if $CONFIGURATION.deeploy_env == 'test'
      @build_stage = args[:build_stage] if args[:build_stage]
      @build_status = args[:build_status] if args[:build_status]

      opts = args[:opts]

      if opts
        @disk = opts[:disk] if opts[:disk]
        @id = opts[:id].to_i if opts[:id]
        @ip = opts[:ip] if opts[:ip]
        
        @ram = get_ram!(opts[:ram])

        @fetch = opts[:fetch] if opts[:fetch]

        if opts[:packages]
          
          # if arg is a string and comes from the database, tokenise it
          if opts[:packages].is_a? String
            opts[:packages] = opts[:packages].split(',')  
          end

          opts[:packages].each do |package|
            @packages.push(package.strip)
          end
          # now filter out the allowed packages
          # set intersection
          @packages &= Deeploy::packages
        end

        if opts[:ports]
          # tokenise if string
          if opts[:ports].is_a? String
            opts[:ports] = opts[:ports].split(',')
          end
          @ports = opts[:ports] 
        end
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

    def get_ram!(ram)
      return @ram if not ram
      ram = ram.to_i
      return ram if ram.is_a? Integer and ram >= 256 and ram <= 1024
      raise ArgumentError, 'RAM must be between 256 and 1024 MB'
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

    def stage
      return [@stages[@build_stage], @build_stage, @stages.length - 1] 
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
        build_stage: db_machine.build_stage.to_i,
        build_status: db_machine.build_status,
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
    def destroy(keep_folders = false, keep_vm = false)
      if Dir.exist?(@root)
        system("VAGRANT_CWD=#{@root} vagrant destroy -f")
        FileUtils.rm_rf(@root) unless keep_folders
      end
      vm = DB::Machine.find(@id)
      if vm && ! keep_vm
        vm.destroy 
      else
        vm.build_status = 'failure'
        vm.save()
      end
    end

    def down()
      if Dir.exist?(@root)
        system("VAGRANT_CWD=#{@root} vagrant halt")
      end
    end

    def up
      if Dir.exist?(@root)
        Dir.chdir(@root) do
          system("VAGRANT_CWD=#{@root} vagrant up")
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
          # sub shell process and wait for it to exit
        result = self.wait_on_build(machine)
      end

      if result && self.alive?
        self.success()
        machine.deployed = true
        machine.build_status = 'success'
        machine.save
        return true
      else
        # keep machine in db and keep log files for debugging and error reporting
        self.destroy(true, true)
        raise Exception, "Errors were encountered, cleaning up: #{$?.inspect}"
      end
    end

    def wait_on_build(machine)

      stages_length = @stages.length - 1
      current_stage = 0
      # put command in background
      command = <<HERE
      echo 'building' > build.log
      if VAGRANT_CWD=#{@root} vagrant up &> #{@root}/vagrant.log ; then
          echo 'success' > #{@root}/build.log
      else
          echo 'failure' > #{@root}/build.log
      fi

HERE
      pid = spawn(command)
      Process.detach(pid)
      counter = 0
      # wait for process to finish, also display build process in the meanwhile
      while counter < 600
        begin
          result = Process.kill 0, pid
        rescue Errno::ESRCH # if process exits, this error will get thrown
          # get build status message
          File.open([@root, 'build.log'].join('/'), 'r') do |f|
            if f.read =~ %r{success}
              puts 'Build successfull !'
              machine.build_stage = stages_length
              machine.save()
              return true
            else
              return false
            end
          end

        end

        # now try to find key moments in the deployment of a machine
        # move on everytime you see that change

        begin
          break if @stages.empty?
          File.open([@root, 'vagrant.log'].join('/'), 'r') do |f|
            stage = @stages[0].keys[0]
            f.each_line do |line|
              # check if the next stage is in the file
              if line =~ %r{#{stage}}
                current_stage += 1
                machine.build_stage = current_stage
                machine.save()
                puts "Status: #{@stages[0].values[0]}"
                @stages.shift()
              end
            end
          end
        rescue Errno::ENOENT
        end

        sleep 10
        counter += 10
      end
      return
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
      
      if available_ips.length == 0
        # write error to log file
        open([@root, 'vagrant.log'].join('/'), 'a') { |f| f << "Unable to allocate IP, all reserved\n"}
        raise IPAddr::InvalidAddressError, "All available ip addresses are reserved"
      end

      @ip = available_ips[-1]
      if Deeploy::valid_ip?(@ip)
        return @ip
      end
      raise IPAddr::InvalidAddressError, "Address #{ip} does not belong to the host range #{host_ip} or is invalid"
    end
  end
end
