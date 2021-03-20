class Api::V1::SpacesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:create, :update, :create_yelp_search]
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
    #handle filtering
    @spaces = @spaces.filter_by_price(filtering_params['price']).with_indicators(filtering_params['indicators'])

    # handle pagination
    @total_count = @spaces.count
    if @fields.length > 0
      @spaces = @spaces.select(@fields)
    end
    @spaces = @spaces.page(@page).per(@per_page)

    # TODO calculate average rating
    render json: { data: @spaces, meta: { total_count: @total_count, page: @page, per_page: @per_page } }, include: @include
  end

  # GET /spaces/:id
  def show
    # TODO calculate average rating
    render json: {data: @space.as_json(:include=>{
      :address =>{},
      :reviews => {except: [:user, :user_id, :updated_at]},
      :photos => {}, 
      :indicators =>{}, 
      :languages => {}
    })}
  end

  def create_yelp_search
    yelp_query = YelpApiSearch.new(yelp_search_params)
    @search_results = yelp_query.submit_search
    @total_count = @search_results.count
    @page = params[:page].to_i || 1
    @per_page = params[:per_page].to_i || 20

    @spaces = @search_results.page(@page).per(@per_page)
    render json: {data: @spaces, meta: { total_count: @total_count, page: @page, per_page: @per_page} }
  end

  # POST /spaces
  def create
    @space = Space.new(space_params)
    if @space.save!
      @space.update_hours_of_operation
      render json: { data: { space: @space } }, status: 201
    else
      render json: { error: 'Unable to create space' }, status:400
    end
  end

  # PUT /spaces/:id
  def update
    if @space
      @space.update(space_params)
      render json: { message: 'Space updated successfully.' }, status: 202
    else
      render json: { error: 'Unable to update space.' }, status: 400
    end
  end

  # DELETE /spaces/:id
  def destroy
    if @space
      @space.destroy
      render json: { message: 'Space deleted successfully.' }, status: 204
    else
      render json: { message: 'Unable to delete space.' }, status: 400
    end
  end

  private

  def space_params
    params.require(:space).permit(:phone, :name, :price_level, :provider_urn, :provider_url, hours_of_op: {}, address_attributes: [:id, :address_1, :address_2, :city, :postal_code, :country, :state], languages_attributes: [:id, :name], indicators_attributes: [:id, :name], photos_attributes: [:id, :url, :cover], reviews_attributes: [:id, :anonymous, :vibe_check, :rating, :content, :user_id])
  end

  def find_space
    @space = Space.find(params[:id])
  end

  def filtering_params
    params.fetch(:filters, {})
  end

  def yelp_search_params
    params.require(:space_search).permit(:location, :term, :radius)
  end

end
