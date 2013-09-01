class AddMemosToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :memo1, :text
    add_column :profiles, :memo2, :text
    add_column :profiles, :memo3, :text
  end
end
