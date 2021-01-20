class CategoryAliasesSpace < ApplicationRecord
    belongs_to :category_alias
    belongs_to :space
end
