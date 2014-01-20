class FormResponse < ActiveRecord::Base

  belongs_to :form_field
  belongs_to :form_version
  belongs_to :user

  validates :form_field, presence: true
  validates :form_id, presence: true
  validates :form_version, presence: true

  before_validation :populate_form_id_and_version

  serialize :details, Hash

  protected

  def populate_form_id_and_version
    unless form_field.nil?
      self.form_version = form_field.form_version
      self.form_id = form_field.form_version.form_id
    end
  end

end

