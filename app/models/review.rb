class Review < ApplicationRecord
  belongs_to :space
  validates :vibe_check, :inclusion => { :in => 1..3 }
end
