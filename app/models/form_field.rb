class FormField < ActiveRecord::Base

  KINDS = ['info', 'short-answer', 'long-answer', 'single-choice', 'multiple-choice']

  belongs_to :form_version, inverse_of: :fields

  validates :form_version, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }

  serialize :details, Hash

end
