class Language < ApplicationRecord
  has_many :space_languages
  has_many :spaces, :through => :space_languages
end
