class Indicator < ApplicationRecord
  has_many :space_indicators
  has_many :spaces, :through => :space_indicators
end
