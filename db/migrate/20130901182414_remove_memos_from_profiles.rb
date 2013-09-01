class RemoveMemosFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :memo1, :string
    remove_column :profiles, :memo2, :string
    remove_column :profiles, :memo3, :string
  end
end
