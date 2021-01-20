class Space < ApplicationRecord
  scope :filter_by_price, -> (price) { where("spaces.price_level <= ?", price) if price }
  scope :with_indicators, -> (ids) { joins(:indicators).group(:id).having('array_agg(indicators.id) @> ARRAY[?]::bigint[]', ids) if ids }

  has_many :reviews, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :space_indicators, dependent: :destroy
  has_many :indicators, :through => :space_indicators
  has_many :space_languages, dependent: :destroy
  has_many :languages, :through => :space_languages
  has_many :category_aliases_spaces
  has_many :category_aliases, :through => :category_aliases_spaces
  has_many :category_buckets, :through => :category_aliases

  validates :price_level, :inclusion => { :in => 1..4 }, :allow_blank => true
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
