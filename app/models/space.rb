class Space < ApplicationRecord
  scope :filter_by_price, -> (price) { where("spaces.price_level <= ?", price) if price }
  scope :filter_by_rating, -> (rating) { where("spaces.avg_rating >= ?", rating) if rating }
  scope :with_indicators, -> (ids) { joins(:indicators).group(:id).having('array_agg(indicators.id) @> ARRAY[?]::bigint[]', ids.split(',')) if ids }

  has_many :reviews, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :space_indicators, dependent: :destroy
  has_many :indicators, :through => :space_indicators
  has_many :space_languages, dependent: :destroy
  has_many :languages, :through => :space_languages
  has_many :category_aliases_spaces, dependent: :destroy
  has_many :category_aliases, :through => :category_aliases_spaces
  has_many :category_buckets, :through => :category_aliases

  validates :price_level, :inclusion => { :in => 1..4 }, :allow_blank => true
  accepts_nested_attributes_for :reviews, :address, :photos, :indicators, :languages, :category_aliases

  before_save :find_indicators #, :find_languages

  def update_hours_of_operation
    yelp_id = self.provider_urn.split("yelp:")
    response = YelpApiSearch.get_yelp_business_info(yelp_id)
    self.update_attribute(:hours_of_op, response.hours)
  end

  def convert_yelp_categories_to_category_alias_spaces(yelp_categories)
    yelp_categories.each do |category|
      begin
        category_alias = CategoryAlias.find_by(alias: category["alias"])
        self.category_aliases_spaces.create(category_alias: category_alias)
      rescue
      end
    end
  end
  
  after_validation :geocode
  geocoded_by :full_address

  def full_address
    [self.address.address_1, self.address.address_2, self.address.city, self.address.postal_code, self.address.country].compact.join(",")
  end

  def calculate_average_rating
    self.update_attribute(:avg_rating, self.reviews.average(:rating))
  end

  private

  def find_languages
    if self.languages.any?
      self.languages = self.languages.map do |language|
        Language.find_by(name: language.name)
      end
    end
  end

  def find_indicators
    if self.indicators.any?
      self.indicators = self.indicators.map do |indicator|
        Indicator.find_by(name: indicator.name)
      end
    end
  end
end
