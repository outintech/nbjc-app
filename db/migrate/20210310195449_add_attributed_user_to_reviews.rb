class AddAttributedUserToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :attributed_user, :string, null: false, default: "Anonymous"
  end
end
