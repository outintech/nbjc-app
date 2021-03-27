class Api::V1::Spaces::ReviewsController < ApplicationController
  include Secured
  skip_before_action :authenticate_request!, only: [:index]
  skip_before_action :get_current_user!, only: [:index]
  skip_before_action :get_auth0_id, only: [:index]
  before_action :load_a_review, only: [:show, :update, :destroy]
  
  def index
    if params[:user_id].blank? || params[:user_id].nil?
      @reviews = load_space_reviews
      render json: { data: @reviews.as_json(except: [:user, :user_id, :updated_at], include: :space) }
    else
      # todo: enforce authorization here?
      # can do so with Secured methods
      # this is adding a bit of obfuscation by not showing the actual review
      # ideally we would enforce this through autorization token instead
      user_review_for_space = load_review_for_space_user
      if (user_review_for_space.length > 0)
        render json: { data: { exists: true }}
      else
        render json: { data: { exists: false }}
      end
    end
  end
  
  def show
    if @review.anonymous? && @review.user.email != "anonymous@email.com"
      @review.user = new_anonymous_user
    end
    render json: {data: @review.as_json(except: [:user, :user_id, :updated_at], include: :space)}
  end

  def create
    check_user

    @review = Review.new(review_params)

    if @review.anonymous == false
      @review.update_attributed_user
    end

    if @review.valid?
      @review.save
      render json: {data: {review: @review} }, status: 201
    else
      render json: { errors: @review.errors }, status: 400
    end
  end
  
  def update
    check_user
    if @review
      @review.assign_attributes(review_params)

      if @review.anonymous == false
        @review.update_attributed_user
      end

      if @review.valid?
        @review.save
        redirect_to api_v1_spaces_review_path(@review)
      else
        render json: { errors: review.errors }, status: 400
      end
    else
      render json: { message: 'We\'re unable to update this review.'}
    end
  end
  
  def destroy
    check_user
    if @review
      @review.destroy
      render json: {message: 'Successfully deleted the review.'}, status: 204
    else
      render json: {error: 'Invalid request'}, status: 400
    end
  end
  
  private
  def load_space_reviews
    Review.all.where({space_id: params[:space_id]})
  end
  
  def load_anonymous_space_reviews
    Review.all.where({anonymous: true, space_id: params[:space_id]})
  end
  
  def load_non_anonymous_space_reviews
    Review.all.where({anonymous: false, space_id: params[:space_id]})
  end
  
  def load_review_for_space_user
    Review.all.where({ space_id: params[:space_id], user_id: params[:user_id]})
  end

  def review_params
    params.require(:review).permit(:anonymous, :vibe_check, :rating, :content, :space_id, :user_id)
  end
  
  def load_a_review
    @review = Review.find(params[:id])
  end
  
  def new_anonymous_user
    User.new(email: "anonymous@email.com",username: "Anonymous")
  end

  def check_user
    # You cannot carry out write operations on behalf of another user
    if params[:user_id] != @current_user.id
      render json: { error: 'Forbidden' }, status: 403
    end
  end
end
