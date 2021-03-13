require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  let!(:category_aliases) {FactoryBot.create_list(:random_category_alias, 20, :random_alias)}

  before do
    get '/api/v1/categories'
  end

  describe "With no search term", type: :request do
    it 'gets all the categories' do
      expect(JSON.parse(response.body)['data'].size).to eq(20)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  describe "with search term", type: :request do
    let!(:category_aliases) do
      FactoryBot.create_list(:random_category_alias, 10, :random_alias)
      FactoryBot.create_list(:random_category_alias, 5, :with_similar_name)
    end

    it 'gets all the categories with the search term in their name' do
      get '/api/v1/categories', params: { :search => 'cafe'}
      expect(JSON.parse(response.body)['data'].size).to eq(5)
    end

    it 'gets all categories if search term is blank' do
      get '/api/v1/categories', params: { search: '' }
      expect(JSON.parse(response.body)['data'].size).to eq(15)
    end
  end
end
