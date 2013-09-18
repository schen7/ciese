class Profile < ActiveRecord::Base
  belongs_to :user, inverse_of: :profiles
  has_many :activities, dependent: :destroy
  accepts_nested_attributes_for :activities, allow_destroy: true
end
