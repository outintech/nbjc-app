class SpaceLanguage < ApplicationRecord
  belongs_to :space
  belongs_to :language

  def self.create_languages_for_space(space_languages, space)
    languages = []
    (space_languages || []).each do |language|
      begin
        db_language = Language.find_by(name: language["name"])
        space_language = SpaceLanguage.new(language: db_language, space: space)
        languages << space_language
      rescue
      end
    end
    languages
  end

  def self.save_languages(space_languages)
    (space_languages || []).each do |language|
      language.save
    end
  end
end
