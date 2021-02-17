class RemoveCoordinatesFromSpaces < ActiveRecord::Migration[6.0]
  def change
    remove_column :spaces, :coordinates, :point
  end
end
