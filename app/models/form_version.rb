class FormVersion < ActiveRecord::Base

  belongs_to :user
  has_one :current_form, inverse_of: :form_version
  has_one :published_form, inverse_of: :form_version
  has_many :fields, -> { order(:id) }, class_name: "FormField",
    inverse_of: :form_version, dependent: :destroy

  validates :name, presence: true
  validates :user, presence: true

  before_save do |form_version|
    form_version.slug = form_version.name.parameterize
  end

  after_save do |form_version|
    form_version.update(form_id: form_version.id) if form_version.form_id.nil?
  end

  def published?
    !published_form.nil?
  end
  
  def slug=(slug)
    write_attribute(:slug, slug.nil? ? slug : slug.parameterize)
  end
  
  def date
    updated_at.nil? ? nil : updated_at.to_formatted_s(:simple)
  end

end
