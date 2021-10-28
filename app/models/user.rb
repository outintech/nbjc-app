class User < ApplicationRecord
  attr_readonly :id, :auth0_id # no user should be able to change the auth0_id after creation
  has_many :reviews
  has_many :user_identities, dependent: :destroy
  has_many :identities, :through => :user_identities
  validates :username, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false, format: { with: /\A[a-zA-Z0-9]+\z/ }
  # allows '.' ,''' and '-' in the name for e.g. Kandis O'Connell or Errol Rutherford Jr. or Ava-Mae
  validates :name, presence: true, allow_blank: false, format: { with: /\A[a-zA-Z\s\.\'\-]+\z/ }
  accepts_nested_attributes_for :identities
  before_save :find_identities

  def self.username_unique_amongst_members(username)
    User.where('username is not null and username != ?', '').where(username: username).count == 0
  end

  private
  def find_identities
    self.identities = self.identities.map do |identity|
      Identity.find_by(name: identity.name)
    end
  end
end
