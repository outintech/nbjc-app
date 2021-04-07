class SpaceIndicator < ApplicationRecord
  belongs_to :space
  belongs_to :indicator

  def self.create_indicators_for_space(space_indicators, space)
    indicators = []
    (space_indicators || []).each do |indicator|
      begin
        db_indicator = Indicator.find_by(name: indicator["name"])
        space_indicator = SpaceIndicator.new(indicator: db_indicator, space: space)
        indicators << space_indicator
      rescue
      end
    end
    indicators
  end

  def self.save_indicators(space_indicators)
    (space_indicators || []).each do |indicator|
      indicator.save
    end
  end
end
