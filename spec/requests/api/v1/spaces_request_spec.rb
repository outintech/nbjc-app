require 'rails_helper'

RSpec.describe "Api::V1::Spaces" do
  describe "GET spaces route" do
    describe "With no search terms or filters", type: :request do
      let!(:spaces) {FactoryBot.create_list(:random_space, 20)}

      before do
        get '/api/v1/spaces'
      end

      it 'gets all the spaces' do
        expect(JSON.parse(response.body)['data'].size).to eq(20)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    end

    describe "With search term", type: :request do
      let!(:spaces) do
        FactoryBot.create_list(:random_space, 10)
        FactoryBot.create_list(:random_space, 5, :with_similar_name)
      end

      it 'gets all the spaces with the search term in their name' do
        get '/api/v1/spaces', params: { :search => 'cafe'}
        expect(JSON.parse(response.body)['data'].size).to eq(5)
      end

      it 'gets all spaces if search term is blank' do
        get '/api/v1/spaces', params: { search: '' }
        expect(JSON.parse(response.body)['data'].size).to eq(15)
      end
    end
  end
end
