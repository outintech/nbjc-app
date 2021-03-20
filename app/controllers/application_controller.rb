class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::RequestForgeryProtection
  protect_from_forgery unless: -> { request.format.json? }
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  respond_to :json

  def handle_record_not_found
    render json: { error: 'User not found' }, status: 404
  end
end
