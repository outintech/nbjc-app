class Api::V1::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :load_a_review, only: [:show, :update, :destroy]
  def index
    @page = 1
    @per_page = 20
    @page = params[:page].to_i unless params[:page].nil? || params[:page].to_i == 0
    @per_page = params[:per_page].to_i unless params[:per_page].nil? || params[:per_page].to_i == 0

    if params[:user_id].blank? || params[:user_id].nil?
      @reviews = load_space_reviews
      @total_count = @reviews.count
      @reviews = @reviews.page(@page).per(@per_page)
      render json: { data: @reviews.as_json(except: [:user, :user_id, :updated_at], include: :space), meta: { total_count: @total_count, page: @page, per_page: @per_page }}
    else
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
  end

  private
  def load_space_reviews
    Review.all.where({space_id: params[:space_id]})
  end
  
  def load_review_for_space_user
    Review.all.where({ space_id: params[:space_id], user_id: params[:user_id]})
  end
end