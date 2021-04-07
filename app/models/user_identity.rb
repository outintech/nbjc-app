class UserIdentity < ApplicationRecord
  belongs_to :user
  belongs_to :identity
  
  def self.create_identities_for_user(user_identities, user)
    identities = []
    user_identities.each do |identity|
      begin
        db_identity = Identity.find_by(name: identity["name"])
        user_identity = UserIdentity.new(identity: db_identity, user: user)
        identities << user_identity
      rescue
      end
    end 
    identities
  end

  def self.save_identities(user_identities)
    user_identities.each do |identity|
      identity.save
    end
  end 
end
