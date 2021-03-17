require 'faker'

FactoryBot.define do
  factory :random_user, class: User do
    username { Faker::Internet.username }
    auth0_id { "provider|1234" }
  end

  factory :user, class: "User" do
    id {1}
    username {"faketestuser"}
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end

  factory :review_user_one, class: "User" do
    id{90210}
    username { "fakereviewuser90210" }
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end

  factory :review_user_two, class: "User" do
    id{8675309}
    username {"fakereviewuser8675309"}
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end

  factory :create_review_user, class: "User" do
    id{98765}
    username {"fakereviewuser98765"}
    auth0_id { "provider|" + Faker::Number.number(digits: 10).to_s }
  end
end

