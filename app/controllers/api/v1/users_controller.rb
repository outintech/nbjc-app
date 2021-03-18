
class Api::V1::UsersController < ApplicationController
  # you need to be logged in to do anything regarding a user
  include Secured
  before_action :find_user, only: [:update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  # uused to search for a user by auth0 id
  def index
    puts "CURRENT USER #{@current_user}"
    if params[:auth0_id].present?
      find_user_by_auth0_id
      if @user
        render json: { data: { user: { user_id: @user.id } } }, status: 200
      else
        render json: { error: 'User not found' }, status: 404
      end
    end
  end

  # GET /users/:id
  def show
    # sparse fields
    @include = []
    @fields = params[:fields].split(',') unless params[:fields].nil? || params[:fields].blank?
    # todo: validate includable fields?
    @include = params[:include].split(',') unless params[:include].nil? || params[:include].blank?

    if @fields.length > 0
      @user = User.where(id: params[:id]).select(@fields)
    else
      find_user
    end

    render json: { data: { user: @user } }, status: 200, include: @include
  end

  def create
    @user = User.new(user_params)
    if @user.save!
      render json: { data: { user: @user } }, status: 201
    else
      render json: { error: 'Unable to save user' }, status: 400
    end
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
    params.require(:user).permit(:id, :username, :auth0_id, :pronouns, :location)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def find_user_by_auth0_id
    @user = User.find_by_auth0_id(params[:auth0_id])
  end

  def handle_record_not_found
    render json: { error: 'User not found' }, status: 404
  end
end
