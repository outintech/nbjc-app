class CreateIndicatorLists < ActiveRecord::Migration[6.0]
  def change
    create_table :indicator_lists do |t|
      t.belongs_to :space, index: { unique: true }, foreign_key: true
      t.boolean :atm, :queer_friendly, :asl_friendly, :wheelchair_accessible, :gender_neutral_restroom, :black_owned, :poc_owned, default: false
      t.string :languages, array: true, default: []
      t.timestamps
    end
    add_index :indicator_lists, :languages, using: 'gin'
  end
end
