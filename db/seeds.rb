require 'open-uri'
require 'json'
require 'faker'
require "csv"

# Please see the README for instructions on adding seed data

Dir.glob("db/seed_data/*.csv") do |file|
  model = Object.const_get(file.split("/").last.split(".").first.singularize.camelcase)
  if !model.name.include?("CategoryAlias")
    CSV.foreach(file, headers: true) do |row|
      model.create!(row.to_hash)
    end
    puts "#{model} seeded"
  end
end

Dir.glob("db/seed_data/category_aliases.csv") do |file|
  model = Object.const_get(file.split("/").last.split(".").first.singularize.camelcase)
    CSV.foreach(file, headers: true) do |row|
      new_alias = CategoryAlias.new(title: row["title"], alias: row["alias"], category_bucket: CategoryBucket.find_by(name: row["category_bucket"]))
      new_alias.save!
    end
    puts "#{model} seeded"
end

# Used for development purposes only
if Rails.env.development?
  puts "Adding spaces"
  open("yelp_response_ny.json") do |file|
    spaces = []
    json_string = File.read(file)
    businesses_data = JSON.parse(json_string)
    businesses = businesses_data["businesses"]
    businesses.each do |business|
      category_aliases = business["categories"].collect{ |category|  CategoryAlias.find_by(alias: category["alias"]) }
      space = {
        "provider_urn": "yelp:" + business["id"],
               "provider_url": business["url"],
               "name": business["name"],
               "price_level": business["price"].nil? ? nil : business["price"].length,
               "address_attributes": {
                                       "address_1": business["location"]["address1"],
                                      "address_2": business["location"]["address2"],
                                      "city": business["location"]["city"],
                                      "postal_code": business["location"]["zip_code"],
                                      "country": business["location"]["country"],
                                      "state": business["location"]["state"]
                                     },
               "category_aliases": category_aliases,
               "photos_attributes": [{ "url": business["image_url"], "cover": true
                                     }],
               "phone": business["phone"],
               "latitude": business["coordinates"]["latitude"],
               "longitude": business["coordinates"]["longitude"],
               "hours_of_op": {
                                "open":[
                                          {
                                            "is_overnight": false,
                                           "start": "0800",
                                           "end": "1500",
                                           "day": 0
                                          },
                                          {
                                            "is_overnight": false,
                                           "start": "0800",
                                           "end": "1500",
                                           "day": 1
                                          },
                                          {
                                            "is_overnight": false,
                                           "start": "0800",
                                           "end": "1500",
                                           "day": 2
                                          },
                                          {
                                            "is_overnight": false,
                                           "start": "0800",
                                           "end": "1500",
                                           "day": 3
                                          },
                                          {
                                            "is_overnight": false,
                                           "start": "0800",
                                           "end": "1600",
                                           "day": 4
                                          },
                                          {
                                            "is_overnight": false,
                                           "start": "0800",
                                           "end": "1800",
                                           "day": 5
                                          },
                                          {
                                            "is_overnight": false,
                                           "start": "0800",
                                           "end": "1600",
                                           "day": 6
                                          }
                                        ]
                              }
      }
      spaces << space
    end
    Space.create!(spaces)
    Space.find_each do |space| 
      @indicators_attributes = Indicator.all.pluck(:id).sample(Faker::Number.between(from: 1, to: Indicator.all.count - 1))
      SpaceIndicator.save_indicators(SpaceIndicator.create_indicators_for_space(Indicator.where(id: @indicators_attributes), space))

      @language_attributes = Faker::Boolean.boolean ? Language.all.pluck(:id).sample(Faker::Number.between(from: 0, to: Language.all.count - 1)) : []
      SpaceLanguage.save_languages(SpaceLanguage.create_languages_for_space(Language.where(id: @language_attributes), space))
    end      
  end
end

puts "Done seeding"

