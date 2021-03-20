class DropDevise < ActiveRecord::Migration[6.0]
  def up
    drop_table :user_roles
    drop_table :roles
    remove_column :users, :email
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
