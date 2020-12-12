class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.belongs_to :space, index: { unique: true }, foreign_key: true
      t.text :url
      t.boolean :cover, default: false
      t.timestamps
    end
  end
end
