class Activity < ActiveRecord::Base
  belongs_to :profile
  belongs_to :program
end
