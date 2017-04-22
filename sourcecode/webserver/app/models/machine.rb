class Machine < ActiveRecord::Base
  
  before_validation :validate_custom_properties
  validates :vm_user, :title, :presence => true
  validates :distribution, :inclusion=> { :in => :get_distribution_keys}
  validates_uniqueness_of :title
  belongs_to :user

  @packages

  def get_distribution_keys
    distros = Deeploy::distributions
    keys = []
    if distros.class == Array
      keys = distros[0].keys
    else
      keys = distros.keys
    end
    # convert to strings, the validator does not use symbols
    for i in 0..keys.length - 1
      keys[i] = keys[i].to_s
    end
    return keys
  end

  def get_packages
    if not @packages
      return @packages = Deeploy::packages()
    else
      return @packages
    end
  end

  def distributions
    return Deeploy::distributions
  end

  private

    def validate_custom_properties
      if self.ram
        if self.ram < 256 or self.ram > 1024
          self.ram = self.ram.to_i # truncate
          errors.add(:ram, 'Random Access Memory must be between 256 and 1024 MB')
        end
      end
      # check if apache and nginx are both selected
      if self.packages
        if self.packages.include? 'nginx' and self.packages.include? 'apache2'
          errors.add(:packages, 'Cannot install nginx and apache2, conflicting packages !')
        end
      end

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
