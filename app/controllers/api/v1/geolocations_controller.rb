class Api::V1::GeolocationsController < ApplicationController
  def index
    # TODO: how do we ensure someone does not 
    # use our service for reverse geo lookup?
    @lat = params[:lat].to_f unless params[:lat].nil? || params[:lat].to_f == 0.0
    @lng = params[:lng].to_f unless params[:lng].nil? || params[:lng].to_f == 0.0
    if @lat.nil? || @lng.nil?
      render json: { errors: { 'lat and lng' => ['is required'] } }, status: :bad_request
    else
      @results = Geocoder.search([@lat, @lng])
      render json: @results.first
    end
  end
end