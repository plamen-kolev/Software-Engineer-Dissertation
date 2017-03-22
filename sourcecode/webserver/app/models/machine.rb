class Machine < ActiveRecord::Base
  attr_accessor :user
  before_validation :validate_custom_properties
  after_save :create_vm
  validates :vm_user, :title, :presence => true
  validates :distribution, :inclusion=> { :in => Deeploy::distributions()}
  validates_uniqueness_of :title
  belongs_to :user

  @packages

  def get_packages
    if not @packages
      return @packages = Deeploy::packages()
    else
      return @packages
    end
  end

  def distributions
    return Deeploy::distributions()
  end

  private

    def create_vm
      begin
        deeploy_user = Deeploy::User::authenticate({token: self.user.token})

        machine = Deeploy::VM.create(
          distribution: self.distribution,
          title: self.title,
          owner: deeploy_user,
          user: self.vm_user,
          opts: {
            'packages' => self.packages,
            'disk' => 0,
            'ports' => self.ports,
            'ram' => 1
          }
        )
        machine.build()
      rescue Exception => e
        self.destroy
        render e
      end
    end

    def validate_custom_properties
      
      if self.ports
        ips = self.ports.split(',')
        
        ips.each do |ip|
          begin
            ip = Integer(ip) 
          rescue 
            errors.add(:ports, "Ports must be numbers")
            return
          end
          
          if ip > 65535 || ip < 1
            errors.add(:ports, "Ports can range from 1 through 65535")
          end
        end
      end
    end

end
