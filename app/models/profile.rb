class Profile < ActiveRecord::Base
  belongs_to :user, inverse_of: :profiles
end
