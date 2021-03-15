class User < ApplicationRecord
  has_many :reviews

  validates :username, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false # format: { with: /\A[a-zA-Z0-9]+\z/ }
end
