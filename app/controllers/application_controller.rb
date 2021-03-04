class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::RequestForgeryProtection
  protect_from_forgery unless: -> { request.format.json? }

  respond_to :json
end
