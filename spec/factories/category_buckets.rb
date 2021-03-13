require 'faker'
FactoryBot.define do
  factory :category_bucket do
    name {Faker::Company.type}
    description {Faker::Company.type}
  end
end
