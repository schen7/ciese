class AddTimestampsToFormResponse < ActiveRecord::Migration
  def change
    add_timestamps :form_responses
  end
end
