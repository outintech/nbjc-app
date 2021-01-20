class CategoryAlias < ApplicationRecord
    belongs_to :category_bucket
    has_many :category_aliases_spaces
    has_many :spaces, :through => :category_aliases_spaces
end
