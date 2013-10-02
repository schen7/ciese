class AddIndexesToProfiles < ActiveRecord::Migration
  def change
    add_index :profiles, :ciese_id
    add_index :profiles, :first_name
    add_index :profiles, :last_name
    add_index :profiles, [:last_name, :first_name]
    add_index :profiles, :email1
    add_index :profiles, :email2
    add_index :profiles, :district
    add_index :profiles, :affiliation
    add_index :profiles, :city
    add_index :profiles, :state
    add_index :profiles, :home_city
    add_index :profiles, :home_state
  end
end
