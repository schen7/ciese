class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :ciese_id, :first_name, :middle_name, :last_name, :prefix, :title,
             :greeting, :ssn, :email1, :email2, :department, :subject, :grade,
             :function, :district, :affiliation, :address_line_1, :address_line_2,
             :city, :state, :zip, :country, :phone1, :phone2, :fax,
             :home_address_line_1, :home_address_line_2, :home_city, :home_state,
             :home_zip, :home_phone, :home_mobile, :home_fax, :memo1, :memo2, :memo3
end
