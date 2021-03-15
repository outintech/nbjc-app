class AddProfileInfo < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :auth0_id, :string
    add_index :users, :auth0_id

    add_column :users, :pronouns, :string
    add_column :users, :location, :string
  end

  def down
    remove_column :users, :auth0_id, :string
    remove_column :users, :pronouns, :string
    remove_column :users, :location, :string
  end
end
