# app/controllers/concerns/secured.rb

# frozen_string_literal: true
module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    before_action :get_current_user!
  end

  private

  def authenticate_request!
    auth_token
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Access denied! Invalid token'] }, status: :unauthorized
  end

  def http_token
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    JsonWebToken.verify(http_token)
  end

  def get_current_user!
    auth0_id = decode_token!
    @current_user = User.find_by_auth0_id(auth0_id)
  end

  def decode_token!
    decoded_token = JsonWebToken.decode(http_token)
    decoded_token[:sub]
  rescue JWT::ExpiredSignature, JWT::VerificationError
    render json: { errors: ['Access denied! Token has expired'] }, status: :unauthorized
  rescue JWT::DecodeError, JWT::VerificationError
    render json: { errors: ['Access denied! Invalid token'] }, status: :unauthorized
  end
end
