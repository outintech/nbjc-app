class ChangeYelpIdColumnForAnyProvider < ActiveRecord::Migration[6.0]
  def change
    rename_column :spaces, :yelp_id, :provider_urn
    rename_column :spaces, :yelp_url, :provider_url
  end
end
