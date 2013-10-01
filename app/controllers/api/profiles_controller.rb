class Api::ProfilesController < ApplicationController
  FILTER_KINDS = ["Keep only", "Leave out"]
  FILTER_ON_OPTIONS = ["all", "any"]
  SORT_FIELDS = Profile.attribute_names.reject do |name|
    ['id', 'user_id', 'created_at', 'updated_at'].include?(name)
  end
  FILTER_FIELDS = SORT_FIELDS + ['program', 'detail', 'start_date', 'end_date']
  STRING_COMPARISON_OPTIONS = {
    "starts with" => "ILIKE ? || '%'",
    "ends with" => "ILIKE '%' || ?",
    "contains" => "ILIKE '%' || ? || '%'",
    "is" => "ILIKE ?"
  }
  DATE_COMPARISON_OPTIONS = {
    "is after" => "> ?",
    "is before" => "< ?",
    "is" => "= ?"
  }
  RESULTS_PER_PAGE = 20

  before_action :api_require_login
  before_action :api_require_staff_or_admin

  def index
    # TODO: Only do a join if filtering on an activity field
    @profiles = Profile.joins("LEFT JOIN activities ON profiles.id = activities.profile_id").uniq
    filter(filters_params)
    record_count = @profiles.count
    offset = get_offset(record_count)
    pages = get_pages(record_count)
    sort(sort_params)
    profile_ids = @profiles.limit(RESULTS_PER_PAGE).offset(offset).map(&:id)
    @profiles = Profile.includes(:activities)
    sort(sort_params)
    render json: @profiles.find(profile_ids), meta: pages, meta_key: "pages"
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      render json: @profile, root: false
    end
  end

  def show
    render json: Profile.find(params[:id]), root: false
  end

  def update
    @profile = Profile.find(params.permit(:id)[:id])
    if @profile.update_attributes(profile_params)
      render json: @profile, root: false
    end
  end

  private

  def profile_params
    activities_fields = {activities: [:id, :program, :detail,
                                      :start_date, :end_date, :_destroy]}
    params.permit(*SORT_FIELDS, activities_fields).tap do |whitelist|
      whitelist[:activities_attributes] = whitelist.delete(:activities)
    end
  end

  def get_offset(record_count)
    offset = (params.permit(:page)[:page].to_i - 1) * RESULTS_PER_PAGE
    if offset < 0
      0
    elsif offset > record_count
      record_count
    else
      offset
    end
  end

  def filters_params
    ActiveSupport::JSON.decode(params.permit(:filters)[:filters] || '[]')
  end

  def sort_params
    ActiveSupport::JSON.decode(params.permit(:sort)[:sort] || '[]')
  end

  def filter(filters_params)
    filters_params.each do |filter|
      condition_strings = []
      values = []
      filter["conditions"].each do |condition|
        field = clean_field(condition["field"])
        comparison = clean_comparison(condition["comparison"], field)
        next if field.nil? || comparison.nil?
        condition_strings.push("#{field} #{comparison}")
        values.push(condition["value"])
      end
      next if condition_strings.empty?
      filter_string = combine_condition_strings(condition_strings, filter["on"])
      @profiles = apply_filter(filter["kind"], filter_string, values)
    end
  end

  def apply_filter(kind, filter_string, values)
    if kind == FILTER_KINDS[0]
      @profiles.where(filter_string, *values)
    elsif kind == FILTER_KINDS[1]
      @profiles.where.not(filter_string, *values)
    end
  end

  def combine_condition_strings(condition_strings, filter_on)
    condition_strings.join(filter_on == FILTER_ON_OPTIONS[0] ? ' AND ' : ' OR ')
  end

  def clean_field(field)
    if !FILTER_FIELDS.include?(field)
      nil
    end
    if ['program', 'detail', 'start_date', 'end_date'].include?(field)
      field = "activities.#{field}"
    end
    field
  end

  def clean_comparison(comparison, field)
    if field.include?("date")
      DATE_COMPARISON_OPTIONS[comparison]
    else
      STRING_COMPARISON_OPTIONS[comparison]
    end
  end
  
  def sort(sort_params)
    return if sort_params.empty?
    order_strings = sort_params.map do |sort_item|
      "profiles.#{sort_item['field']} #{sort_item['order'].chomp('ending').upcase}"
    end
    @profiles = @profiles.order(*order_strings)
  end

  def get_pages(record_count)
    (record_count.to_f / RESULTS_PER_PAGE).ceil
  end
end
