require_relative 'user'
require_relative 'confmanager'
require 'ipaddr'
# require 'figaro'

module Deeploy
  class VM < Configurable
    # attr_reader :root, :manifest, :name, :distribution, :ip, :user, :password, :vm_user, :vm_password, :valid
    attr_accessor :owner, :distribution, :root, :manifest, :user, :password, :ip, :title, :configuration, :id, :disk, :ram, :packages, :ports
    

    
    def self.create(args = {})
      # validation

      instance = Deeploy::VM.new
      # ram and disk
      instance.disk = args[:opts][:disk] ||= 5
      instance.ram = args[:opts][:ram] ||= 1

      # additional packages
      instance.packages = args[:opts][:packages] ||= []

      # open ports
      instance.ports = args[:opts][:ports] ||= []

      if ! instance._verify_owner(args[:owner])
        return false
      end
      instance.owner = args[:owner]

      # allowed list of distros
      distributions = {
        'ubuntu' => 'ubuntu/xenial64',
        'debian' => 'debian/jessie64',
        'centos' => 'bento/centos-7.2'
      }

      instance.distribution = distributions[args[:distribution]]
      if ! instance.distribution
        $stderr.puts "Distribution '#{args[:distribution]}' is not a recognized option,\nOptions are: #{distributions.keys}, aborting"
        # exit 1
        return false
      end

      # human friendly virtual machine name
      instance.title = "#{args[:title]}_#{$CONFIGURATION.rails_env}"
      instance.ip = Deeploy::VM::generate_ip()
      puts $CONFIGURATION.machine_path
      vm_dir = $CONFIGURATION.machine_path
      # set the folder path (absolute path on the os)
      instance.root = [vm_dir, "userspace", instance.owner.email, instance.title].join('/')
      instance.manifest = instance.root + '/manifests'

      instance.user = args[:user]
      instance.password = args[:password]
      instance.configuration = Deeploy::Confmanager.new(instance)
      return instance

    end

    # takes machine name and owner object
    def self.get(args = {})
      db_machine = DB::Machine.where(user_id: args[:owner].id, title: args[:title]).take
      if ! db_machine
        $stderr.puts("Unable to find machine '#{args[:title]}' for user '#{args[:owner].email}'")
        return false
      end
      machine = self.new
      machine.id = db_machine.id
      vm_dir = $CONFIGURATION.machine_path ||= "#{File.expand_path("#{File.dirname(__FILE__)}")}", "/../"
      machine.root = [vm_dir, "userspace", args[:owner].email, db_machine.title].join('/')
      machine.owner = args[:owner]

      machine._verify_owner(args[:owner])
      if db_machine.user_id != machine.owner.id
        $stderr.puts("The user does not own the virtual machine")
        exit 1
      end

      return machine
    end

    def _verify_owner(owner)
      if owner.class != Deeploy::User
        $stderr.puts "Expecting Helper::User object, got #{owner.class}"
        # exit 1
        return false
      else

        if ! DB::User.find(owner.id)
          $stderr.puts "Invalid user"
          return false
        end
      end
      return true
    end

    def destroy()
      if Dir.exists?(@root)
        Dir.chdir("#{@root}") do
          result = system(
            "vagrant destroy -f"
          )
        end

        FileUtils.rm_rf("#{@root}")
      end

      vm = DB::Machine.find(@id)
      vm.destroy if vm
    end

    def down()
      if Dir.exists?(@root)
        Dir.chdir("#{@root}") do
          result = system(
            "vagrant halt"
          )
        end
      end
    end

    def up()
      if Dir.exists?(@root)
        Dir.chdir("#{@root}") do
          result = system(
            "vagrant up"
          )
        end
      end
    end
    def build()
      FileUtils.mkdir_p(@manifest)
      @configuration.writeall(shell: "#{@manifest}/setup.sh", vagrant: "#{@root}/Vagrantfile", puppet: "#{@manifest}/default.pp")

      new_machine = DB::Machine.create(title: @title, user_id: @owner.id, ip: @ip, deployed: false, distribution: @distribution, user: @owner.id)
      self.id = new_machine.id
      result = false

      Dir.chdir("#{@root}") do
        result = system("vagrant up")
      end

      if result
        self.success()
        new_machine.deployed=true
        new_machine.save
        return true
      else
        $stderr.puts("Errors were encountered: #{$?.inspect}")
        return false
      end
    end

    def in_db?()

      if @owner.get_machine(@title)
        return true
      end
      return false
    end

    def in_dir?()
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
    User:\t\t|\t#{@user}
#{"-"*50}
    Distribution:\t|\t#{@distribution}
#{"="*50}
HERE
    end

    def self.generate_ip()

      # Your own ip address and netmask
      # https://www.snip2code.com/Snippet/339491/Use-Ruby-to-get-your-ip-address-and-netm
      sockips = Socket.getifaddrs.select{|ifaddr| ifaddr.addr.afamily == Socket::AF_INET && ifaddr.name == $CONFIGURATION.network_interface}. \
        map{|ifaddr| [ifaddr.addr, ifaddr.netmask].map &:ip_address}

      # grab netmask for the specified interface
      host_ip, netmask = sockips.first
      if not host_ip or not netmask
        $stderr.puts("Interface '#{$CONFIGURATION.network_interface}' did not return an ip or mask for the host !\n.") # Recreating virtual network.")
        exit 1
        # cleanup interfaces
        # ifaces = %x[VBoxManage list hostonlyifs].scan(/[^-]vboxnet\d+/)
        #
        # for i in (0..ifaces.length - 1)
        #   %x[VBoxManage hostonlyif remove #{ifaces[i]}]
        #   %x[VBoxManage hostonlyif create]
        #   %x[VBoxManage hostonlyif ipconfig #{ifaces[i]} --ip 17#{i}.168.1.1 --netmask 255.255.0.0]
        # end

      end

      # map to string flatters the object array to strign array
      range = IPAddr.new("#{host_ip}/#{netmask}").to_range.map(&:to_s)

      # blacklist broadcast ips ranges based on the host's ip, e.g. if the host has ip of 12.200.30.20, 12.200.30.0 and 12.200.30.255 will be blacklisted
      tokenized_ip = host_ip.split('.')
      tokenized_ip.pop
      tokenized_ip = tokenized_ip.join('.')

      blacklisted_ips = DB::Machine.all.collect { |obj| obj.ip }
      blacklisted_ips += ["#{tokenized_ip}.0", "#{tokenized_ip}.255", host_ip]

      # array difference of available ips and taken ips
      available_ips = range - blacklisted_ips

      @ip = available_ips[-1]
    end
  end
end
