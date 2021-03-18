# lib/json_web_token.rb

# frozen_string_literal: true
require 'net/http'
require 'uri'

class JsonWebToken
  def self.verify(token)
    JWT.decode(token, nil,
               true, # Verify the signature of this token
               algorithms: 'RS256',
               iss: ENV["AUTH0_APP_DOMAIN"],
               verify_iss: true,
               aud: Rails.application.secrets.auth0_api_audience,
               verify_aud: true) do |header|
      jwks_hash[header['kid']]
    end
  end

  def self.jwks_hash
    jwks_raw = Net::HTTP.get URI(ENV["AUTH0_APP_DOMAIN"]+".well-known/jwks.json") # if error might be domain issue
    jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
    Hash[
      jwks_keys
      .map do |k|
        [
          k['kid'],
          OpenSSL::X509::Certificate.new(
            Base64.decode64(k['x5c'].first)
          ).public_key
        ]
      end
    ]
  end

  def self.decode(token)
    body = JWT.decode(token, nil, false)[0]
    HashWithIndifferentAccess.new body
  end
end
