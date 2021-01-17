class CategoryAlias < ApplicationRecord
    belongs_to :category_bucket
    belongs_to :space
end
