class Api::V1::IndicatorsController < ApplicationController
  def index
    @indicators = Indicator.all
    render json: @indicators
  end
end
