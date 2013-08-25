module ProfilesHelper
  def profile_fields
    Profile.attribute_names.reject do |name|
      ['id', 'user_id', 'created_at', 'updated_at'].include?(name)
    end
  end
end
