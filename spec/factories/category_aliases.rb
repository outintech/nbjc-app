FactoryBot.define do
  factory :random_category_alias, class: CategoryAlias do
    title { Faker::Company.type }
    category_bucket
    
    trait :random_alias do
      after(:build) do |category_alias|
        category_alias.alias = Faker::Company.name
        category_alias.save
      end
    end

    trait :with_similar_name do
      after(:build) do |category_alias|
        category_alias.alias = Faker::Company.name
        category_alias.title = category_alias.title + 'cafe'
        category_alias.save
      end
    end
  end
end
