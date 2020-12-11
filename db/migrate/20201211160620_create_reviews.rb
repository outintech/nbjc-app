class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.boolean :anonymous
      t.integer :vibe_check, :rating
      t.text :content
      t.belongs_to :space, index: { unique: true }, foreign_key: true
      #TODO add user ref
      t.timestamps
    end
  end
end
