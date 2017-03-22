
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  if Rails.env.development?  
    skip_before_action :verify_authenticity_token
  end
end
