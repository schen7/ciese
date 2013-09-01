class ProfilesController < ApplicationController
  FILTER_KINDS = ["Keep only", "Leave out"]

  FILTER_ON_OPTIONS = ["all", "any"]

  FILTER_FIELDS = Profile.attribute_names.reject do |name|
    ['id', 'user_id', 'created_at', 'updated_at'].include?(name)
  end + ['program', 'detail', 'start_date', 'end_date']

  SORT_FIELDS = Profile.attribute_names.reject do |name|
    ['id', 'user_id', 'created_at', 'updated_at'].include?(name)
  end

  COLUMN_FIELDS = Profile.attribute_names.reject do |name|
    ['id', 'user_id', 'created_at', 'updated_at'].include?(name)
  end + ['activities']

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

  def index
    respond_to do |format|
      format.html
      format.json do
        @profiles = Profile.joins(:activities).uniq
        filter(ActiveSupport::JSON.decode(filters_params))
        sort(ActiveSupport::JSON.decode(sort_params))
        profile_ids = @profiles.pluck(:id)
        render json: Profile.includes(:activities).find(profile_ids), root: false
      end
    end
  end

  private

  def filters_params
    params.permit(:filters)[:filters] || '[]'
  end

  def sort_params
    params.permit(:sort)[:sort] || '[]'
  end

  def filter(filter_params)
    filter_params.each do |filter|
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
end
