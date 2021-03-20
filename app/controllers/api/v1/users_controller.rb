
class Api::V1::UsersController < ApplicationController
  # you need to be logged in to do anything regarding a user
  include Secured
  before_action :find_user, only: [:update, :destroy]
  skip_before_action :get_current_user!, only: [:create]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  # uused to search for a user by auth0 id
  def index
    if params[:auth0_id].present?
      find_user_by_auth0_id
      # We want to make sure that you can't ask about someone else's auth0_id
      if @user.id == @current_user.id
        render json: { data: { user: { id: @user.id } } }, status: 200
      else
        render json: { error: 'Forbidden' }, status: 403
      end
    end
  end

  # GET /users/:id
  def show
    # As our current profiles go, you can't ask for information about another user
    if verify_user
      # sparse fields
      @include = []
      @fields = params[:fields].split(',') unless params[:fields].nil? || params[:fields].blank?
      # todo: validate includable fields?
      @include = params[:include].split(',') unless params[:include].nil? || params[:include].blank?

      if @fields && @fields.length > 0
        @user = User.where(id: params[:id]).select(@fields)
      else
        find_user
      end
      if @user 
        render json: { data: { user: @user } }, status: 200, include: @include
      end
    else
      render json: { error: 'Forbidden' }, status: 403
    end
  end

  def create
    # check that the provided :auth0_id corresponds to the token auth0_id
    if params[:auth0_id] != @auth0_id
      render json: { error: 'Forbidden' }, status: 403
    else 
      @user = User.new(user_params)
      if @user.save!
        render json: { data: { user: @user } }, status: 201
      else
        render json: { error: 'Unable to save user' }, status: 400
      end
    end
  end

  def update
    if verify_user && @current_user.update!(user_params)
      render json: { data: { user: @user } }, status: 201
    else
      render json: { errors: @current_user.errors }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:id, :username, :auth0_id, :pronouns, :location)
  end

  def find_user
    @user = User.find(params[:id])
    if @user == nil
      raise ActiveRecord::RecordNotFound
    end
  end

  def find_user_by_auth0_id
    @user = User.find_by_auth0_id(params[:auth0_id])
    if @user == nil
      raise ActiveRecord::RecordNotFound
    end
  end

  def handle_record_not_found
    render json: { error: 'User not found' }, status: 404
  end

  def verify_user
    params[:id] != @current_user.id
  end
end
