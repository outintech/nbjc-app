require 'faker'

FactoryBot.define do
  factory :address, class: Address do
    address_1 {Faker::Address.street_address}
    address_2 {Faker::Address.secondary_address}
    city {Faker::Address.city_prefix + Faker::Address.city_suffix}
    postal_code {Faker::Address.postcode}
    country { "US" }
    state {Faker::Address.state_abbr}
  end
  
  factory :random_space, class: Space do
    provider_urn {"yelp:"+Faker::Crypto.md5}
    provider_url {Faker::Internet.url}
    name {Faker::Company.name}
    price_level {Faker::Number.between(from: 1, to: 4)}

    trait :with_similar_name do
      after(:build) do |space|
        space.name = space.name + " Cafe"
        space.save
      end
    end

    trait :with_price_one do
      after(:build) do |space|
        space.price_level = 1
      end
    end

    
    trait :with_price_two do
      after(:build) do |space|
        space.price_level = 2
      end
    end

    
    trait :with_price_three do
      after(:build) do |space|
        space.price_level = 3
      end
    end
  end
end
