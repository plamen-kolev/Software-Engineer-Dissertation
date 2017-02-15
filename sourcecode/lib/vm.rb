require_relative 'person'
require_relative 'confmanager'

module Helper
  class VM < Configurable
    attr_reader :root, :manifest, :name, :distribution, :ip, :user, :password, :vm_user, :vm_password
    
    @owner
    @root
    @manifest
    @name
    @conf
    @user
    @password
    @ip
    @db_instance

    def initialize(args = {})
      super()

      # allowed list of distros
      @distributions = {
        'ubuntu' => 'ubuntu/xenial64',
        'debian' => 'debian/jessie64',
        'centos' => 'bento/centos-7.2'
      } 
      
      @owner = args[:owner]

      @distribution = @distributions[args[:distribution]]
      if ! @distribution
        $stderr.puts "Distribution '#{distro}' is not a recognized option,\nOptions are: #{@distributions.keys}, aborting"
        exit 1
      end

      # human friendly virtual machine name
      @name = args[:name]
      @ip = self.generate_ip

      # set the folder path (absolute path on the os)
      @root = [Dir.pwd, "userspace", @owner.user.email, @name].join('/')
      @manifest = @root + '/manifests'

      # validate relevant fields
      [@ip, @name, @owner, @root, @manifest].each do | key, value |
        if ! key
          $stderr.puts "Initialization failed, missing '#{key} argument'"
          exit 1
        end
      end

      @user = args[:user]
      @password = args[:password]
      
      # configuration manages puppet, shell and vagrant
      @conf = Helper::Confmanager.new(self)
      # when using machine as wrapper, will load existing machine from db
      # otherwise will create db instance and flush it upon save
    end

    def build()
      FileUtils.mkdir_p(@manifest)
      @conf.writeall(shell: "#{@manifest}/setup.sh", vagrant: "#{@root}/Vagrantfile", puppet: "#{@manifest}/default.pp")
      
      new_machine = Machine.create(title: @name, user_id: @owner.user.id, ip: @ip, deployed: false)

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

      if @owner.get_machine(@name)        
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
    VM NAME:\t\t|\t#{@name}
    IP:\t\t\t|\t#{@ip}
    User:\t\t|\t#{@user}
#{"-"*50}
    Distribution:\t|\t#{@distribution}
#{"="*50}
HERE
    end

    def generate_ip()
      
      # Your own ip address and netmask
      # https://www.snip2code.com/Snippet/339491/Use-Ruby-to-get-your-ip-address-and-netm
      sockips = Socket.getifaddrs.select{|ifaddr| ifaddr.addr.afamily == Socket::AF_INET && ifaddr.name == ENV['NETWORK_INTERFACE']}. \
        map{|ifaddr| [ifaddr.addr, ifaddr.netmask].map &:ip_address}

      # grab netmask for the specified interface
      host_ip, netmask = sockips.first

      # map to string flatters the object array to strign array
      range = IPAddr.new("#{host_ip}/#{netmask}").to_range.map(&:to_s)

      # blacklist broadcast ips ranges based on the host's ip, e.g. if the host has ip of 12.200.30.20, 12.200.30.0 and 12.200.30.255 will be blacklisted 
      tokenized_ip = host_ip.split('.')
      tokenized_ip.pop
      tokenized_ip = tokenized_ip.join('.')
      
      blacklisted_ips = Helper::Machine.all.collect { |obj| obj.ip }
      blacklisted_ips += ["#{tokenized_ip}.0", "#{tokenized_ip}.255", host_ip]
      
      # array difference of available ips and taken ips
      available_ips = range - blacklisted_ips
      
      @ip = available_ips[-1]
    end
  end
end