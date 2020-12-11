class Space < ApplicationRecord
  has_many :reviews
  has_one :indicator_list
  validates :price_level, :inclusion => { :in => 1..4 }
end
