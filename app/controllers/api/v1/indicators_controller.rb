class Api::V1::IndicatorsController < ApplicationController
  def index
    @indicators = Indicator.all
    render json: { data: @indicators }
  end
end
