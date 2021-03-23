class UserIdentity < ApplicationRecord
  belongs_to :user
  belongs_to :identity
end
