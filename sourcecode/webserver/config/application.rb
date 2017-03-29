require_relative 'boot'

require 'rails/all'
require_relative '../app/workers/deploy_worker'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# test if virtual interface is setup, if not, a notice will appear
($network_host, $network_mask) = Deeploy::network_interface()

$has_network = false
if $network_host and $network_mask and $network_host.split(".")[0].to_i != 192
  $has_network = true  
end

module Deepsky
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
