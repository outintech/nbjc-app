class CreateJoinTableCategoryAliasesSpaces < ActiveRecord::Migration[6.0]
  def change
    create_join_table :category_aliases, :spaces do |t|
      t.index :category_alias_id
      t.index :space_id
    end
  end
end
