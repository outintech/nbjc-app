class AddAverageRatingToSpaces < ActiveRecord::Migration[6.0]
  def change
    add_column :spaces, :avg_rating, :float
  end
end
