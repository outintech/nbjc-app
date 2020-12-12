class CreateSpaceLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :space_languages do |t|
      t.references :space
      t.references :language
      t.timestamps
    end
  end
end
