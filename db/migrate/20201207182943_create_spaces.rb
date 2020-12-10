class CreateSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :spaces do |t|
      t.string :yelp_id, :phone
      t.text :name, :yelp_url, :url
      t.jsonb :hours_of_op
      t.point :coordinates
      
      t.integer :price_level
      t.timestamps
    end
  end
end
