class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.integer :user_id

      t.string :ciese_id

      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :prefix
      t.string :title
      t.string :greeting
      t.string :ssn
      t.string :email1
      t.string :email2
      t.string :department
      t.string :subject
      t.string :grade
      t.string :function

      t.string :district
      t.string :affiliation
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone1
      t.string :phone2
      t.string :fax

      t.string :home_address_line_1
      t.string :home_address_line_2
      t.string :home_city
      t.string :home_state
      t.string :home_zip
      t.string :home_phone
      t.string :home_mobile
      t.string :home_fax

      t.string :memo1
      t.string :memo2
      t.string :memo3

      t.timestamps
    end
  end
end
