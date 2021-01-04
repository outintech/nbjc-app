require 'faker'

FactoryBot.define do
  factory :address, class: Address do
    address_1 {Faker::Address.street_address}
    address_2 {Faker::Address.secondary_address}
    city {Faker::Address.city_prefix + " " + Faker::Address.city_suffix}
    postal_code {Faker::Address.postcode}
    country { "US" }
    state {Faker::Address.state_abbr}
  end

  ## INDICATOR
  factory :indicator, class: Indicator do
    name {Faker::Color.color_name}
  end

  ## SPACE
  factory :random_space, class: Space do
    name {Faker::Company.name}

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

  factory :space_with_indicators, parent: :random_space do
    transient do
      space { FactoryBot.create(:indicator) }
    end

    after(:create) do |space, evaluator|
      space.indicators << evaluator.indicators
      space.save
    end
  end
end
