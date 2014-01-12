class FormVersion < ActiveRecord::Base

  belongs_to :user
  has_one :current_form, inverse_of: :form_version
  has_one :published_form, inverse_of: :form_version
  has_many :fields, class_name: "FormField", inverse_of: :form_version

  validates :slug, presence: true
  validates :name, presence: true
  validates :user, presence: true

  def slug=(slug)
    write_attribute(:slug, slug.nil? ? slug : slug.parameterize)
  end

  def date
    updated_at.to_formatted_s(:simple)
  end

end
