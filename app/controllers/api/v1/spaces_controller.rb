class Api::V1::SpacesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_space, only: [:show, :update, :destroy]

  # GET /spaces
  def index
    @spaces = Space.all
    render json: @spaces
  end

  # GET /spaces/:id
  def show
    render json: @space.to_json(:include => [:address, :reviews, :photos, :indicators, :languages])
  end

  # POST /spaces
  def create
    @space = Space.new(space_params)
    if @space.save!
      render json: @space, status: 201
    else
      render json: { error: 'Unable to create space' }, status:400
    end
  end

  # PUT /spaces/:id
  def update
    if @space
      @space.update(space_params)
      render json: { message: 'Space updated successfully.' }, status: 200
    else
      render json: { error: 'Unable to update space.' }, status: 400
    end
  end

  # DELETE /spaces/:id
  def destroy
    if @space
      @space.destroy
      render json: { message: 'Space deleted successfully.' }, status: 200
    else
      render json: { message: 'Unable to delete space.' }, status: 400
    end
  end

  private

  def space_params
    params.require(:space).permit(:phone, :name, :price_level, :yelp_id, :yelp_url, hours_of_op: {}, address_attributes: [:id, :address_1, :address_2, :city, :postal_code, :country, :state], languages_attributes: [:id, :name], indicators_attributes: [:id, :name], photos_attributes: [:id, :url, :cover], reviews_attributes: [:id, :anonymous, :vibe_check, :rating, :content])
  end

  def find_space
    @space = Space.find(params[:id])
  end
end
