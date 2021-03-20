class User < ApplicationRecord
  attr_readonly :id, :auth0_id # no user should be able to change the auth0_id after creation
  has_many :reviews

  validates :username, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false # format: { with: /\A[a-zA-Z0-9]+\z/ }
end
