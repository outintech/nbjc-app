class Space < ApplicationRecord
  validates :price_level, :inclusion => { :in => 1..4 }
end
