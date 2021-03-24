require 'yelp/fusion'

class YelpApiSearch

    def initialize(args={})
        @location = args[:location]
        @term = args[:term]
        @radius = args[:radius]

    end

    def submit_search
        @yelp_client = Yelp::Fusion::Client.new(ENV['YELP_API_KEY'])
        responses = @yelp_client.search(@location, {term: @term, radius: @radius})
        filtered_responses = filter_yelp_responses(responses)
        converted_responses = convert_filtered_responses(filtered_responses)
        converted_responses
    end

    def filter_yelp_responses(responses)
        db_spaces_ids = Space.all.map {|space| space.provider_urn}
        yelp_spaces = responses.businesses
        filtered_spaces = yelp_spaces.reject {|yelp_space| db_spaces_ids.any?(/#{yelp_space.id}/) == true }
    end

    def convert_filtered_responses(filtered_responses)
        converted_responses = []
        filtered_responses.each do |filtered_space|
            converted_space = YelpSpaceResponse.new(filtered_space)
            converted_responses << converted_space
        end
        converted_responses
    end

    def self.get_yelp_business_info(yelp_id)
        return @yelp_client.business(yelp_id)
    end
end