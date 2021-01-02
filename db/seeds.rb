# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'
require 'faker'

languages = {name: "Armenian"}, {name: "Azerbaijani"}, {name: "Bulgarian"}, {name: "Catalan"}, {name: "Chinese"}, {name: "Czech"}, {name: "Dutch"}, {name: "English"}, {name: "Estonian"}, {name: "Finnish"}, {name: "French"}, {name: "German"}, {name: "Hebrew"}, {name: "Hindi"}, {name: "Hungarian"}, {name: "Icelandic"}, {name: "Indonesian"}, {name: "Italian"}, {name: "Japanese"}, {name: "Korean"}, {name: "Persian"}, {name: "Polish"}, {name: "Portuguese"}, {name: "Romanian"}, {name: "Russian"}, {name: "Slovak"}, {name: "Spanish"}, {name: "Swedish"}, {name: "Turkish"}, {name: "Ukrainian"}, {name: "Vietnamese"}

indicators = [{name: "LGBTQIA+ Friendly"}, {name: "Gender-Neutral Restroom"}, {name: "Black-Owned"}, {name: "Black-Friendly"}, {name: "Inclusive"}, {name: "Multilingual"}, {name: "Trans-Owned"}, {name: "Trans-Trained"}, {name: "Accessible"}]

puts "Adding languages"
Language.create(languages)


puts "Adding indicators"
Indicator.create(indicators)

puts "Adding spaces"
open("yelp_response_ny.json") do |file|
  spaces = []
  json_string = File.read(file)
  businesses_data = JSON.parse(json_string)
  businesses = businesses_data["businesses"]
  businesses.each do |business|
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
      "languages_attributes": Faker::Boolean.boolean ? languages.sample(Faker::Number.between(from: 0, to: languages.length - 1)) : [],
      "indicators_attributes": indicators.sample(Faker::Number.between(from: 0, to: indicators.length - 1)),
      "photos_attributes": [{ "url": business["image_url"], "cover": true
                            }],
      "phone": business["phone"],
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
end

puts "Done seeding"
