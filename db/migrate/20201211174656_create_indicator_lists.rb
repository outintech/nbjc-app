class CreateIndicatorLists < ActiveRecord::Migration[6.0]
  def change
    create_table :indicator_lists do |t|

      t.timestamps
    end
  end
end
