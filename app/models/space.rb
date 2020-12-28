class Space < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :space_indicators, dependent: :destroy
  has_many :indicators, :through => :space_indicators
  has_many :space_languages, dependent: :destroy
  has_many :languages, :through => :space_languages

  validates :price_level, :inclusion => { :in => 1..4 }
  accepts_nested_attributes_for :reviews, :address, :photos, :indicators, :languages
end
