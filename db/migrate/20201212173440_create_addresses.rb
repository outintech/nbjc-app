class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.belongs_to :space, index: { unique: true }, foreign_key: true
      t.text :address_1, :address_2
      t.string :city, :postal_code, :country, :state
      t.timestamps
    end
  end
end
