class Space < ApplicationRecord
  has_many :reviews
  has_one :address
  has_many :photos
  has_many :space_indicators
  has_many :indicators, :through => :space_indicators
  has_many :space_languages
  has_many :languages, :through => :space_languages
  validates :price_level, :inclusion => { :in => 1..4 }
end
