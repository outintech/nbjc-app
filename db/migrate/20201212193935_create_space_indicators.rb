class CreateSpaceIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :space_indicators do |t|
      t.references :space
      t.references :indicator
      t.timestamps
    end
  end
end
