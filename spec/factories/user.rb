require 'faker'

FactoryBot.define do
  factory :random_user, class: User do
    username { Faker::Internet.username }
    auth0_id { "provider|1234" }
  end
end
