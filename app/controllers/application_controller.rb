class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery unless: -> { request.format.json? }

  # uncomment when we have a protected controller
  # before_action :authenticate_user!
  
  respond_to :json
end
