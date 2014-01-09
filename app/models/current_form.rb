class CurrentForm < ActiveRecord::Base

  belongs_to :form_version, inverse_of: :current_form

end
