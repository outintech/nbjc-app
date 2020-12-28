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

  before_save :find_languages, :find_indicators

  private

  def find_languages
    self.languages = self.languages.map do |language|
      Language.find_by(name: language.name)
    end
  end

  def find_indicators
    self.indicators = self.indicators.map do |indicator|
      Indicator.find_by(name: indicator.name)
    end
  end
end
