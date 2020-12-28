# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Adding languages"

languages = Language.create([{name: "Armenian"}, {name: "Azerbaijani"}, {name: "Bulgarian"}, {name: "Catalan"}, {name: "Chinese"}, {name: "Czech"}, {name: "Dutch"}, {name: "English"}, {name: "Estonian"}, {name: "Finnish"}, {name: "French"}, {name: "German"}, {name: "Hebrew"}, {name: "Hindi"}, {name: "Hungarian"}, {name: "Icelandic"}, {name: "Indonesian"}, {name: "Italian"}, {name: "Japanese"}, {name: "Korean"}, {name: "Persian"}, {name: "Polish"}, {name: "Portuguese"}, {name: "Romanian"}, {name: "Russian"}, {name: "Slovak"}, {name: "Spanish"}, {name: "Swedish"}, {name: "Turkish"}, {name: "Ukrainian"}, {name: "Vietnamese"}])

puts "Adding indicators"
indicators = Indicator.create([{name: "ATM"}, {name: "ASL"}, {name: "Gender-neutral Restroom"}, {name: "Black-owned"}, {name: "POC-owned"}])

puts "Done seeding"
