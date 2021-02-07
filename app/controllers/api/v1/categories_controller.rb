class Api::V1::CategoriesController < ApplicationController
  # GET /categories
  def index
    @page = 1
    @per_page = 20
    @page = params[:page].to_i unless params[:page].nil? || params[:page].to_i == 0
    @per_page = params[:per_page].to_i unless params[:per_page].nil? || params[:per_page].to_i == 0
    if params[:search].blank? || params[:search].nil?
      @categories = CategoryAlias.all
    else
      @terms = params[:search].downcase
      @categories = CategoryAlias.where("lower(category_aliases.title) like :search", search: "%#{@terms}%")
      @total_count = @categories.count
    end
    @total_count = @categories.count
    @categories = @categories.page(@page).per(@per_page)
    render json: { data: @categories, meta: { total_count: @total_count, page: @page, per_page: @per_page } }
  end
end
