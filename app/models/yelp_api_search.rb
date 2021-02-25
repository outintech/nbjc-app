require 'yelp/fusion'

class YelpApiSearch

    def initialize(args={})
        @location = args[:location]
        @term = args[:term]
    end

    def submit_search
        client = Yelp::Fusion::Client.new('4JZx7F4yaVL6glAhlcfhvSCd0KWs8uqJjEj46KXnzlC6-WxC72CwgATWi60vdoNftKxtqzb7aZO8W7gH-z13WLCccDYeFm_vKDemcyR4sFiMj41ipa-oAfGF4Nw2YHYx')
        responses = client.search(@location, {term: @term})
        filtered_responses = filter_yelp_responses(responses)
        convert_filtered_responses(client, filtered_responses)
    end

    def filter_yelp_responses(responses)
        db_spaces_ids = Space.all.map {|space| space.provider_urn}
        yelp_spaces = responses.businesses
        filtered_spaces = yelp_spaces.reject {|yelp_space| db_spaces_ids.any?(/#{yelp_space.id}/) == true }
    end

    def convert_filtered_responses(yelp_client, filtered_responses)
        converted_responses = []
        filtered_responses.each do |filtered_space|
            response = yelp_client.business(filtered_space.id)
            converted_space = YelpSpaceResponse.new(response.business)
            converted_responses << converted_space
        end
        converted_responses
    end
end