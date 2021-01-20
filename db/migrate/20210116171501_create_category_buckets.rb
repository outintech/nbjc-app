class CreateCategoryBuckets < ActiveRecord::Migration[6.0]
  def change
    create_table :category_buckets do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
