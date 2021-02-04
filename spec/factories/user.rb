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
end