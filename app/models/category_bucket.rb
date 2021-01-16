class CategoryBucket < ApplicationRecord
    has_many :category_aliases
    #  has_many :spaces, :through => :category_aliases

end
