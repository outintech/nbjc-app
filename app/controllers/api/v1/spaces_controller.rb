class Api::V1::SpacesController < ApplicationController
  skip_before_action :verify_authenticity_token
  # GET /spaces
  def index
    @spaces = Space.all
    render json: @spaces
  end
  # def show
  # end
  def create
    @space = Space.new(space_params)
    if @space.save!
      render json: @space
    else
      render json: { error: 'Unable to create space' }.to_json, status:400, content_type: 'application/json'
    end
  end
  # def update
  # end
  # def destroy
  # end

  private

  def space_params
    params.require(:space).permit(:phone, :name, :price_level)
  end
end
