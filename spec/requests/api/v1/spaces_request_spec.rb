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

    describe "with search term", type: :request do
      let!(:spaces) do
        FactoryBot.create_list(:random_space, 10)
        FactoryBot.create_list(:random_space, 5, :with_similar_name)
      end

      it 'gets all the spaces with the search term in their name' do
        get '/api/v1/spaces', params: { :search => 'cafe'}

      end

      it 'gets all spaces if search term is blank' do
        get '/api/v1/spaces', params: { search: '' }
        expect(JSON.parse(response.body)['data'].size).to eq(15)
      end
    end

    describe 'with filters', type: :request do
      let!(:indicators) do
        FactoryBot.create_list(:indicator, 5)
      end
      let!(:spaces) do
        FactoryBot.create_list(:random_space, 5, :with_price_one)
        FactoryBot.create_list(:random_space, 3, :with_price_two)
        FactoryBot.create_list(:random_space, 1, :with_price_three)
        FactoryBot.create_list(:space_with_indicators, 2, indicators: indicators)
      end

      it 'returns all spaces with a price at or below the filter' do
        get '/api/v1/spaces', params: { filters: { price: 2 } }
        expect(JSON.parse(response.body)['data'].size).to eq(8)
      end

      it 'returns all spaces with the specified indicators' do
        get '/api/v1/spaces', params: { filters: { indicators: [6,7]}}
        expect(JSON.parse(response.body)['data'].size).to eq(2)
      end
    end
  end

  describe "POST spaces route" do
    before do
      Language.create({name: "English"})
      Indicator.create({name: "Indicator"})
      post '/api/v1/spaces', params: {
             space: {
               provider_urn: "yelp:" + Faker::Crypto.md5,
               provider_url: Faker::Internet.url,
               name: Faker::Company.name,
               price_level: Faker::Boolean.boolean ? Faker::Number.between(from: 1, to: 4) : nil,
               phone: "+" + Faker::Number.number(digits: 10).to_s,
               hours_of_op: {
                 start: "0800",
                 stop: "1500",
                 day: 0
               },
               address_attributes: {
                 address_1: Faker::Address.street_address,
                 address_2: Faker::Address.secondary_address,
                 city: Faker::Address.city_prefix + " " + Faker::Address.city_suffix,
                 postal_code: Faker::Address.postcode,
                 country: "US",
                 state: Faker::Address.state_abbr
               },
               photos_attributes: [
                 {
                   url: Faker::Internet.url,
                   cover: true
                 }
               ],
               languages_attributes: [
                 {
                   name: "English"
                 }
               ],
               indicators_attributes: [
                 {
                   name: "Indicator"
                 }
               ]
             }
           }
    end

    it 'returns the space' do
      expect(JSON.parse(response.body)['data'].size).to eq(1)
    end

    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end
  end
end
