class Space < ApplicationRecord
  has_many :reviews
  validates :price_level, :inclusion => { :in => 1..4 }
end
