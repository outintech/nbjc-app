class Review < ApplicationRecord
  belongs_to :space
  belongs_to :user
  validates :vibe_check, :inclusion => { :in => 1..3 }, allow_nil: true
end
