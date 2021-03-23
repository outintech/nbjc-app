class Api::V1::IdentitiesController < ApplicationController
  def index
    @identities = Identity.all
    render json: { data: @identities }
  end
end
