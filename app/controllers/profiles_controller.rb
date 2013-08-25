class ProfilesController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        filter(ActiveSupport::JSON.decode(filters_params))
        render json: @profiles
      end
    end
  end

  private

  def profiles_params
    params.permit(filters: [:kind, :on, conditions: [:field, :condition, :value]])
  end

  def filters_params
    params.permit(:filters)[:filters] || '[]'
  end

  def filter(filters)
    puts "Filters: #{filters}"
    @profiles = Profile.all
    filters.each do |filter|
      puts "Filter: #{filter}"
      conditions = filter["conditions"].map do |condition|
        ["#{check_field(condition["field"])} #{check_comparison(condition["comparison"])}", condition["value"]]
      end
      templates, values = conditions.transpose
      template = templates.join(filter["on"] == 'all' ? ' and ' : ' or ')
      filter_arr = values.unshift(template)
      @profiles = filter["kind"] == 'include' ? @profiles.where(filter_arr) : @profiles.where.not(filter_arr)
    end
  end

  def check_field(field)
    field
  end

  def check_comparison(comparison)
    puts comparison
    mapping = {
      "starts with" => "ilike ? || '%'",
      "ends with" => "ilike '%' || ?",
      "contains" => "ilike '%' || ? || '%'",
      "is" => "ilike ?"
    }
    puts mapping[comparison]
    mapping[comparison] || mapping["starts with"]
  end
end
