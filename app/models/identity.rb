class Identity < ApplicationRecord
  has_many :user_identities
  has_many :users, :through => :user_identities
end
