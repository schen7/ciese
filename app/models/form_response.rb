class FormResponse < ActiveRecord::Base

  belongs_to :form_field
  belongs_to :form_version
  belongs_to :user

  before_validation :populate_form_id_and_version
  before_validation :ensure_details_is_set

  validates :form_field, presence: true
  validates :form_id, presence: true
  validates :form_version, presence: true
  validate :validate_response_details

  serialize :details, Hash

  protected

  def populate_form_id_and_version
    unless form_field.nil?
      self.form_version = form_field.form_version
      self.form_id = form_field.form_version.form_id
    end
  end

  def ensure_details_is_set
    self.details = {} if details.nil?
  end

  def validate_response_details
    unless form_field.nil?
      send("validate_#{form_field.kind.underscore}_response".to_sym)
    end
  end

  def validate_info_response
  end

  def validate_short_answer_response
    check_if_response_required_and_blank
  end

  def validate_long_answer_response
    check_if_response_required_and_blank
  end

  def validate_single_choice_response
    check_if_response_required_and_blank
    response = details.fetch(:response, "")
    ok_choices = form_field.details.fetch(:choices, []).map { |choice| choice["label"] }
    if !response.empty? && !ok_choices.include?(response)
      errors.add(:response, "Must be a valid choice")
    end
  end

  def validate_multiple_choice_response
    responses = details.fetch(:responses, {})
    ok_choices = form_field.details.fetch(:choices, []).map { |choice| choice["label"] }
    if form_field.details[:required] && !responses.values.include?("1")
      errors.add(:response, "Can't be blank")
    end
    if responses.keys.reject { |k| ok_choices.include?(k) }.any?
      errors.add(:response, "Must be a valid choice")
    end
  end

  def check_if_response_required_and_blank
    if form_field.details[:required]
      response = details.fetch(:response, "")
      errors.add(:response, "Can't be blank") if response.empty?
    end
  end
end

