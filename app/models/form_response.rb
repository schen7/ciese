class FormResponse < ActiveRecord::Base

  belongs_to :form_field
  belongs_to :form_version
  belongs_to :user

  validates :form_field, presence: true

  def form_field=(form_field)
    super(form_field)
    if !form_field.nil?
      write_attribute(:form_version_id, form_field.form_version_id)
      write_attribute(:form_id, form_field.form_version.form_id)
    end
  end

  def form_version=(ignored_version)
  end

  def form_id=(ignored_id)
  end

end

