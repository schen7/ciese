class FormResponse < ActiveRecord::Base

  belongs_to :form_version, inverse_of: :responses
  belongs_to :user
  has_many :field_responses, class_name: 'FormFieldResponse', inverse_of: :form_response

  before_validation :populate_form_id

  validates :form_id, presence: true
  validates :form_version, presence: true

  def date
    updated_at.nil? ? nil : updated_at.to_formatted_s(:simple)
  end

  protected

  def populate_form_id
    unless form_version.nil?
      self.form_id = form_version.form_id
    end
  end

end

