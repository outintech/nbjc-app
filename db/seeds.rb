# DO NOT MODIFY THIS FILE
# Please see the README for instructions on adding seed data

require "csv"

Dir.glob("db/seed_data/*.csv") do |file|
  model = Object.const_get(file.split("/").last.split(".").first.singularize.camelcase)
  CSV.foreach(file, headers: true) do |row|
    model.create!(row.to_hash)
  end
end
