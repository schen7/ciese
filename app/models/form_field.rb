class FormField < ActiveRecord::Base

  KINDS = ['info', 'short_anwer', 'medium_answer', 'long_answer', 'single_choice', 'multiple_choice']

  belongs_to :form_version, inverse_of: :fields

  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :required, presence: true, inclusion: { in: [true, false] }

end
