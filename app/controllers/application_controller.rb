class ApplicationController < ActionController::API
  protect_from_forgery with: :exception

  # uncomment when we have a protected controller
  # before_action :authenticate_user!
  
  respond_to :json
end
