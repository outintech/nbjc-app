class Review < ApplicationRecord
  belongs_to :space
  belongs_to :user
  validates :vibe_check, :inclusion => { :in => 1..3 }, allow_nil: true


  def update_attributed_user
    if self.anonymous == false
      username = self.user.try(:username)
      self.attributed_user = username
    end
  end
end
