class Program < ActiveRecord::Base
  serialize :details, Array
end
