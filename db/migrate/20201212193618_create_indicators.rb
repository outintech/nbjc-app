class CreateIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :indicators do |t|
      t.string :name
      t.timestamps
    end
  end
end
