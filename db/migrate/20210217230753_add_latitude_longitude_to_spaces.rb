class AddLatitudeLongitudeToSpaces < ActiveRecord::Migration[6.0]
  def change
    add_column :spaces, :latitude, :decimal
    add_column :spaces, :longitude, :decimal
  end
end
