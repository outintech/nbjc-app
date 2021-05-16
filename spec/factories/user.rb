require 'faker'

FactoryBot.define do
  factory :random_user, class: User do
    username { "user" + SecureRandom.alphanumeric(5) + "name" }
    name { Faker::Name.name }
    auth0_id { "provider|1234" }
  end

  factory :user, class: "User" do
    id {1}
    username {"faketestuser"}
    name { Faker::Name.name }
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end

  factory :review_user_one, class: "User" do
    id{90210}
    username { "fakereviewuser90210" }
    name { Faker::Name.name }
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end

  factory :review_user_two, class: "User" do
    id{8675309}
    username {"fakereviewuser8675309"}
    name { Faker::Name.name }
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end

  factory :create_review_user, class: "User" do
    id{98765}
    username {"fakereviewuser98765"}
    name { Faker::Name.name }
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end

  factory :user_with_identity, parent: :random_user do
    transient do
      user { FactoryBot.create(:identity) }
    end

    after(:create) do |user, evaluator|
      user.identities << evaluator.identities
      user.save
    end
  end
end

