require 'rails_helper'
require 'support/auth_helper'
include AuthHelper

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:random_user) }
  describe "GET users route" do
    describe "Without a valid auth token" do
      it 'gets an auth error' do
        request.headers["Authorization"] = "Bearer INVALID_TOKEN"
        get :index, params: { auth0_id: "provider|1234" }
        expect(response.status).to eq(401)
      end
    end

    describe "With a valid auth token" do
      before do 
        controller.stub(:authenticate_request! => true)
      end
      
      it 'gets returns an error if user is not found' do
        controller.stub(:get_auth0_id => nil)
        controller.stub(:get_current_user! => nil)
        newUser = "provider|5678"
        get :index, params: { auth0_id: newUser }
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)["error"]).to eq("Not found")
      end

      it 'gets a user id given an auth0 id' do
        @auth0_id_test = "provider|1234"
        payload = { sub: @auth0_id_test }
        token = JWT.encode payload, nil, 'none'
        request.headers["Authorization"] = "Bearer #{token}"
        get :index, params: { auth0_id: @auth0_id_test }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['id']).to eq(user.id)
      end

      it 'gets a user\'s profile' do
        @auth0_id_test = "provider|1234"
        payload = { sub: @auth0_id_test }
        token = JWT.encode payload, nil, 'none'
        request.headers["Authorization"] = "Bearer #{token}"
        get :show, params: { id: 4, user: { id: 4 } }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['user']['auth0_id']).to eq(@auth0_id_test)
        expect(JSON.parse(response.body)['data']['user']['username']).to eq(user.username)
      end
    end
  end

  describe "POST users route" do
    describe "Without a valid auth token" do
      it 'gets an auth error' do
        request.headers["Authorization"] = "Bearer INVALID_TOKEN"
        get :create, params: { auth0_id: "provider|1234" }
        expect(response.status).to eq(401)
      end
    end

    describe "Without a valid name" do
      test_user_without_name = {
        auth0_id: "provider|5678",
        username: "username",
        identities_attributes: [
          {
            name: "Identity",
          }
        ]
      }
      test_user_with_invalid_name = {
        auth0_id: "provider|5678",
        username: "username",
        name: "n@ame with symbols!;",
        identities_attributes: [
          {
            name: "Identity",
          }
        ]
      }
      before do
        Identity.create({name: "Identity"})
        controller.stub(:authenticate_request! => true)
        controller.stub(:get_auth0_id => nil)
      end

      it 'rejects without name' do
        post :create, params: { user: test_user_without_name }
        expect(response.status).to eq(400)
      end

      it 'reject with invalid name' do
        post :create, params: { user: test_user_with_invalid_name }
        expect(response.status).to eq(400)
      end
    end

    describe "With a valid auth token" do
      test_user = {
        auth0_id: "provider|5678",
        username: "username",
        name: 'test user',
        identities_attributes: [
          {
            name: "Identity",
          }
        ]
      }
      before do
        Identity.create({name: "Identity"})
        controller.stub(:authenticate_request! => true)
        controller.stub(:get_auth0_id => nil)
      end

      it 'creates a new user' do
        post :create, params: { user: test_user }
        expect(response).to have_http_status(:created)
        data = JSON.parse(response.body)['data']
        expect(data['user']['name']).to eq('test user')
        expect(data['user']['identities'].length).to eq(1)
        expect(data['user']['identities'][0]['name']).to eq('Identity')
      end
    end

    describe "Without an identitiy" do
      test_user = {
        auth0_id: "provider|5679",
        username: "username1",
        name: 'test user',
      }
      before do
        Identity.create({name: "Identity"})
        controller.stub(:authenticate_request! => true)
        controller.stub(:get_auth0_id => nil)
      end

      it 'creates a new user' do
        post :create, params: { user: test_user }
        expect(response).to have_http_status(:created)
        data = JSON.parse(response.body)['data']
        expect(data['user']['identities'].length).to eq(0)
      end
    end
  end

  describe "UPDATE users route" do
    describe "Without a valid auth token" do
      it 'gets an auth error' do
        request.headers["Authorization"] = "Bearer INVALID_TOKEN"
        get :update, params: { id: 1, user: { id: 1, username: "newUserName" } }
        expect(response.status).to eq(401)
      end
    end

    describe "With a valid auth token" do
      before do 
        controller.stub(:authenticate_request! => true)
        Identity.create({ name: "Identity" })
      end
      it 'updates a user\'s profile' do
        @auth0_id_test = "provider|1234"
        payload = { sub: @auth0_id_test }
        token = JWT.encode payload, nil, 'none'
        request.headers["Authorization"] = "Bearer #{token}"        
        get :update, params: { id: 13, user: { id: 13, username: "newUserName", name: "new name of user", identities_attributes: [{ name: "Identity" }] } }
        expect(response).to have_http_status(:created)

        get :show, params: { id: 13, include: 'identities'}
        data = JSON.parse(response.body)['data']
        expect(data['user']['name']).to eq('new name of user')
        expect(data['user']['identities'].length).to eq(1)
        expect(data['user']['identities'][0]['name']).to eq('Identity')
      end
    end
  end
end
