require 'rails_helper'
require 'support/auth_helper'
include AuthHelper

RSpec.describe "Api::V1::Users" do
  describe "GET users route" do
    let!(:user) { FactoryBot.create(:random_user) }

    it 'gets an auth error if accessed without a valid token' do
      get '/api/v1/users', params: { auth0_id: "provider|1234" }, headers: { "Authorization": "Bearer INVALID_TOKEN" }
      expect(response.status).to eq(401)
    end

    it 'gets returns an error if user is not found' do
      newUser = "provider|5678"
      get '/api/v1/users', params: { auth0_id: newUser }, headers: auth_header
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)["error"]).to eq("User not found")
    end

    it 'gets a user id given an auth0 id with valid authorization' do
      get '/api/v1/users', params: { auth0_id: "provider|1234" }, headers: auth_header
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['user']['user_id']).to eq(user.id)
    end
  end
end
