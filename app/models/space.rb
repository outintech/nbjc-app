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

  # before_save :find_languages

  def update_from_yelp_direct
    yelp_id = self.provider_urn.split("yelp:")[1]
    begin
      response = YelpApiSearch.new.get_yelp_business_info(yelp_id)
      self.update_attribute(:hours_of_op, response.business.hours[0])
      self.handle_yelp_photos(response.business.photos)
      self.convert_yelp_categories_to_category_alias_spaces(response.business.categories)
    rescue
    end
  end

  def convert_yelp_categories_to_category_alias_spaces_test(yelp_categories)
    yelp_aliases = yelp_categories.map do |entry| 
      entry.alias
    end
    yelp_aliases.each do |yelp_alias|
      begin
        # safe catch in case the category alias is not successfully found
        category_alias = CategoryAlias.find_by(alias: yelp_alias)
        self.category_aliases_spaces.create(category_alias: category_alias)
      rescue
      end
    end
  end

  def handle_yelp_photos(yelp_photos)
    yelp_photos.each do |photo_url|
      self.photos.create(url: photo_url)
    end
  end

  # NOTE: We don't want to hit the geocoder API unless it's production
  # for example, when seeding the database, we already provide latitude and longitude data
  # so we don't geocode seeding data
  if Rails.env.production?
    after_save :geocode
    geocoded_by :full_address
  end

  def full_address
    [self.address.address_1, self.address.address_2, self.address.city, self.address.postal_code, self.address.country].compact.join(",")
  end

  def calculate_average_rating
    self.update_attribute(:avg_rating, self.reviews.average(:rating))
  end

  def self.create_space_with_yelp_params(params)
    space = Space.new(
      provider_urn: params["provider_urn"], 
      phone: params["phone"], 
      name: params["name"], 
      provider_url: params["provider_url"], 
      price_level: params["price_level"],  
      latitude: params["latitude"], 
      longitude: params["longitude"],
    )
    Address.new(
      address_1: params["address_attributes"]["address_1"],
      address_2: params["address_attributes"]["address_2"],
      city: params["address_attributes"]["city"],
      postal_code: params["address_attributes"]["postal_code"],
      country: params["address_attributes"]["country"],
      state: params["address_attributes"]["state"],
      space: space
    )
    
    return space
  end

  private

  def find_languages
    if self.languages.any?
      self.languages = self.languages.map do |language|
        Language.find_by(name: language.name)
      end
    end
  end
end
