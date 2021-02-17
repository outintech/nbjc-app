FactoryBot.define do
  factory :role do
    name { "admin" }
  end
  
  factory :user_role do
    role
    user
  end

  factory :admin, class: "User" do
    email { "admin@nbjcapp.com" }
    user_roles { user_role(user: user) }
  end

  factory :user, class: "User" do
    id {1}
    email {"faketest@user.com"}
    password {"qwertyFake"}
    username {"faketestuser"}
  end

  factory :review_user_one, class: "User" do
    id{90210}
    email {"fakereview90210@user.com"}
    password {"qwertyFake"}
    username {"fakereviewuser90210"}
  end

  factory :review_user_two, class: "User" do
    id{8675309}
    email {"fakereview8675309@user.com"}
    password {"qwertyFake"}
    username {"fakereviewuser8675309"}
  end
end