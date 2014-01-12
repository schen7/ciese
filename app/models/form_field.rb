class FormField < ActiveRecord::Base

  KINDS = ['info', 'short-answer', 'medium-answer', 'long-answer', 'single-choice', 'multiple-choice']

  belongs_to :form_version, inverse_of: :fields

  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :required, presence: true, inclusion: { in: [true, false] }

end
