class Review < ApplicationRecord
  belongs_to :space
  belongs_to :user
  validates :vibe_check, :inclusion => { :in => 1..3 }, allow_nil: true
  after_save :update_average_rating

  def update_attributed_user
    if self.anonymous == false
      username = self.user.try(:username)
      self.attributed_user = username
    end
  end

  def update_average_rating
    space = Space.find(self.space.id)
    space.update_attribute(:avg_rating, space.reviews.average(:rating))
  end
end
