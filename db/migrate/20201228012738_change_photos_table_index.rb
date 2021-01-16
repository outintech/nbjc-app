class ChangePhotosTableIndex < ActiveRecord::Migration[6.0]
  remove_index :photos, name: 'index_photos_on_space_id'
  remove_index :reviews, name: 'index_reviews_on_space_id'
  remove_index :reviews, name: 'index_reviews_on_user_id'

  add_index :photos, :space_id
  add_index :reviews, :space_id
  add_index :reviews, :user_id
end
