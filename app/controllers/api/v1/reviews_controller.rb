class Api::V1::ReviewsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    before_action :load_a_review, only: [:show, :update, :destroy]
  
    def index
      if params[:userxw_id].blank? || params[:user_id].nil?
        anonymous_reviews = load_anonymous_space_reviews
        non_anon_reviews = load_non_anonymous_space_reviews
        anon_user = new_anonymous_user
    
        @all_reviews_safe = []
    
        anonymous_reviews.each do |ar|
          ar.user = anon_user
          @all_reviews_safe << ar
        end
    
        @all_reviews_safe << non_anon_reviews
        render json: { data: @all_reviews_safe }
      elsex
        # todo: enforce authorization here?
        # this is adding a bit of obfuscation by not showing the actual review
        # ideally we would enforce this through autorization token instead
        user_review_for_space = load_review_for_space_user
        if (user_review_for_space.length > 0)
          render json: { data: { exists: true }}
        else
          render json: { data: { exists: false }}
        end
      end
  
      @all_reviews_safe << non_anon_reviews
      render json: { data: @all_reviews_safe },include: [:space]
    end
  
    def show
      if @review.anonymous? && @review.user.email != "anonymous@email.com"
        @review.user = new_anonymous_user
      end
      render json: {data: @review}, include: [:space]
    end
  
    def create
      # todo: this allows you to create a review for another user.
      @review = Review.new(review_params)
      if @review.valid?
        @review.save
        render json: {data: {review: @review} }, status: 201
      else
        render json: { errors: @review.errors }, status: 400
      end
    end
  
    def update
      if @review
        @review.assign_attributes(review_params)
        if @review.valid?
          @review.save
          redirect_to api_v1_space_review_path(@review)
        else
          render json: { errors: review.errors }, status: 400
        end
      else
        render json: { message: 'We\'re unable to update this review.'}
      end
    end
  
    def destroy
      if @review
        @review.destroy
        render json: {message: 'Successfully deleted the review.'}, status: 204
      else
        render json: {error: 'Invalid request'}, status: 400
      end
    end
  
    private
    def load_space_reviews
      Review.find_by(params[:space_id])
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
  
  end 