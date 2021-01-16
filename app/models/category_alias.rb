class CategoryAlias < ApplicationRecord
    belongs_to :category_bucket
    # has_many :spaces
end
