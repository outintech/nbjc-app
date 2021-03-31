class YelpSpaceResponse
    def initialize(data)
        @yelp_id = data.id
        @provider_urn = "yelp:#{data.id}"
        @phone = data.phone
        @name = data.name
        @provider_url = data.url
        @coordinates = data.coordinates
        @price_level = data.price && data.price.length > 0 ? data.price.length : nil
        @categories = data.categories
        @location = data.location
        @distance = data.distance
    end

end