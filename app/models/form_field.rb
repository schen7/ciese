class FormField < ActiveRecord::Base

  KINDS = [
    'info',
    'short-answer',
    'long-answer',
    'single-choice',
    'multiple-choice', 
    'address'
  ]

  belongs_to :form_version, inverse_of: :fields
  has_many :responses, class_name: "FormFieldResponse", inverse_of: :form_field

  validates :form_version, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }

  serialize :details, Hash

end
