
class Api::V1::UsersController < ApplicationController
  # you need to be logged in to do anything regarding a user
  include Secured

  # GET /users
  def index
    # TODO pass an auth0 id and 
  end

  # GET /users/:id
  def show
  end

  def update
    if current_user.update_attributes(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end
  private
  def user_params
    params.require(:user).permit(:username)
  end
end
