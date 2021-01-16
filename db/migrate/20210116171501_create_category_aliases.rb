class CreateCategoryAliases < ActiveRecord::Migration[6.0]
  def change
    create_table :category_aliases do |t|
      t.string :alias 
      t.string :title
      t.references :category_buckets
      t.timestamps
    end
  end
end
