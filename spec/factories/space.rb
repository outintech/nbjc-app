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

    trait :with_languages do
      after(:build) do |space|
        space.languages << Language.sample(Faker::Number.between(from: 0, to: Language.all.length - 1))
      end
    end
  end
end
