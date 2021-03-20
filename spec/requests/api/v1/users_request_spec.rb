require 'rails_helper'
require 'support/auth_helper'
include AuthHelper

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:random_user) }
  describe "GET users route" do
    describe "Without a valid auth token" do
      it 'gets an auth error if accessed without a valid token' do
        request.headers["Authorization"] = "Bearer INVALID_TOKEN"
        get :index, params: { auth0_id: "provider|1234" }
        expect(response.status).to eq(401)
      end
    end

    describe "With a valid auth token" do
      it 'gets returns an error if user is not found' do
        controller.stub(:authenticate_request! => true)
        controller.stub(:get_current_user! => nil)
        newUser = "provider|5678"
        get :index, params: { auth0_id: newUser }
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)["error"]).to eq("User not found")
      end

      it 'gets a user id given an auth0 id with valid authorization' do
        controller.stub(:authenticate_request! => true)
        @auth0_id = "provider|1234"
        payload = { sub: @auth0_id }
        token = JWT.encode payload, nil, 'none'
        puts "TOKEN #{token}"
        request.headers["Authorization"] = "Bearer #{token}"
        get :index, params: { auth0_id: @auth0_id }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['user']['user_id']).to eq(user.id)
      end
    end
  end
end
