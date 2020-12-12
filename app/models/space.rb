class Space < ApplicationRecord
  has_many :reviews
  has_one :indicator_list
  has_one :address
  validates :price_level, :inclusion => { :in => 1..4 }
end
