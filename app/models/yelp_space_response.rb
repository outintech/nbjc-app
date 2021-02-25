class YelpSpaceResponse
    def initialize(data)
        @provider_urn = "yelp:#{data.id}"
        @phone = data.phone
        @name = data.name
        @provider_url = data.url
        @hours_of_op = data.hours
        @coordinates = data.coordinates
        @price_level = data.price.length
        @categories = data.categories
    end

end