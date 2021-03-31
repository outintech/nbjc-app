class Api::V1::SpacesController < ApplicationController
  include Secured
  skip_before_action :verify_authenticity_token

  # The only routes not secured are the GET /spaces and GET /spaces/:id
  skip_before_action :authenticate_request!, only: [:index, :show]
  skip_before_action :get_current_user!, only: [:index, :show]
  skip_before_action :get_auth0_id, only: [:index, :show]

  before_action :find_space, only: [:show, :update, :destroy]
  # GET /spaces
  def index
    @page = 1
    @per_page = 20
    @page = params[:page].to_i unless params[:page].nil? || params[:page].to_i == 0
    @per_page = params[:per_page].to_i unless params[:per_page].nil? || params[:per_page].to_i == 0
    
    @fields = []
    @include = []
    @fields = params[:fields].split(',') unless params[:fields].nil? || params[:fields].blank?
    # todo: validate includable fields?
    @include = params[:include].split(',') unless params[:include].nil? || params[:include].blank?

    @search = params[:search] unless params[:search].nil? || params[:search].blank?
    @category = params[:category] unless params[:category].nil? || params[:category].blank?

    # handle search
    if @search.nil? && @category.nil?
      @spaces = Space.all
    elsif !!(@search && @category)
      @terms = @search.downcase
      @spaces = Space.where("lower(spaces.name) LIKE :search", search: "%#{@terms}%")
      @category_alias = CategoryAlias.find_by(alias: @category)
      @cas = CategoryAliasesSpace.where(category_alias: @category_alias)
      @spaces = @spaces.or(Space.where(category_aliases_spaces: @cas))
    elsif !!(@search)
      @terms = @search.downcase
      @spaces = Space.where("lower(spaces.name) LIKE :search", search: "%#{@terms}%")
    else
      @category_alias = CategoryAlias.find_by(alias: @category)
      @cas = CategoryAliasesSpace.where(category_alias: @category_alias)
      @spaces = Space.where(category_aliases_spaces: @cas)
    end

    # location based search 
    @location = params[:location]
    @lat = params[:lat].to_f unless params[:lat].nil? || params[:lat].to_f == 0.0
    @lng = params[:lng].to_f unless params[:lng].nil? || params[:lng].to_f == 0.0
    @distance_filter = filtering_params['distance'].to_i unless filtering_params['distance'].nil? || filtering_params['distance'].to_i == 0

    @locationParam = nil
    if @location
      @locationParam = @location
    elsif !(@lat.nil? || @lng.nil?)
      @locationParam = [@lat, @lng]
    end
    if !@locationParam.nil?
      if @distance_filter.nil?
        @spaces = @spaces.near @locationParam
      else
        @spaces = @spaces.near(@locationParam, @distance_filter)
      end
    end
    #handle filtering
    @indicators = filtering_params['indicators']
    @spaces = @spaces.filter_by_price(filtering_params['price']).filter_by_rating(filtering_params['rating']).with_indicators(@indicators)

    # handle pagination
    if (@indicators.nil? || @indicators.blank?) && @locationParam.nil?
      @total_count = @spaces.count
    elsif @locationParam.nil?
      # when there are indicators, there is a join with the space_indicators table with a 
      # group by on spaces.id. So the actual count of spaces found matching is simply the
      # number of rows of this count query
      @total_count = @spaces.count.size 
    elsif (@indicators.nil? || @indicators.blank?)
      @total_count = @spaces.count(:all)
    else 
      @total_count = @spaces.count(:all).size
    end
    if @fields.length > 0
      @spaces = @spaces.select(@fields)
    end

    @spaces = @spaces.page(@page).per(@per_page)

    render json: { data: @spaces, meta: { total_count: @total_count, page: @page, per_page: @per_page } }, include: @include
  end

  # GET /spaces/:id
  def show
    render json: {data: @space.as_json(:include=>{
      :address =>{},
      :reviews => {except: [:user, :user_id, :updated_at]},
      :photos => {}, 
      :indicators =>{}, 
      :languages => {},
      :category_buckets => {}
    })}
  end

  def create_yelp_search
    yelp_query = YelpApiSearch.new(yelp_search_params)
    @search_results = yelp_query.submit_search
    render json: {data: @search_results}
  end

  # POST /spaces
  def create
    check_user
    @space = Space.create_space_with_yelp_params(space_params)
    @review = Review.new(space_params["reviews_attributes"])
    @review.space = @space
    if @space.save!
      @review.save
      if Rails.env.production?
        @space.update_from_yelp_direct
      end
      render json: { data: { space: @space } }, status: 201
    else
      render json: { error: 'Unable to create space' }, status:400
    end
  end

  # PUT /spaces/:id
  def update
    check_user
    if @space
      @space.update(space_params)
      render json: { message: 'Space updated successfully.' }, status: 202
    else
      render json: { error: 'Unable to update space.' }, status: 400
    end
  end

  # DELETE /spaces/:id
  def destroy
    check_user
    if @space
      @space.destroy
      render json: { message: 'Space deleted successfully.' }, status: 204
    else
      render json: { message: 'Unable to delete space.' }, status: 400
    end
  end

  private

  def space_params
    params.require(:space).permit(
      :phone, 
      :name, 
      :price_level, 
      :provider_urn, 
      :provider_url,
      :latitude,
      :longitude,
      :category_aliases_attributes=> [:alias],
      :address_attributes=> [:address_1, :address_2, :city, :postal_code, :country, :state], 
      :indicators_attributes=> [:name], 
      :reviews_attributes => [:anonymous, :rating, :content, :user_id]
    )
  end

  def find_space
    @space = Space.find(params[:id])
  end

  def filtering_params
    params.fetch(:filters, {})
  end

  def yelp_search_params
    params.require(:space_search).permit(:location, :term, :radius, :zipcode, :user_id, :auth0_id)
  end

  def check_user
    if params[:reviews_attributes].present?
      if params[:reviews_attributes][:user_id] != @current_user.id
        render json: { error: 'Forbidden' }, status: 403
      end
    end
  end

end
