require 'csv'

module CieseDb

  PROFILE_FIELDS = [
    :id, :last_name, :middle_name, :first_name, :prefix, :title,
    :department, :subject, :grade, :function, :affiliation, :ssn,
    :address_line_1, :address_line_2, :city, :state, :zip, :country,
    :district, :greeting, :phone1, :phone2, :fax, :home_address_line_1,
    :home_address_line_2, :home_city, :home_state, :home_zip, :home_phone,
    :home_fax, :home_mobile, :email1, :email2, :memo1, :memo2, :memo3
  ]
  PROGRAM_FIELDS = [:id, :name, :details]
  ACTIVITY_FIELDS = [
    :id, :profile_id, :program, :detail, :start_date, :end_date
  ]

  BASE_PATH = Rails.root.join("tmp/ciesedb")

  def CieseDb.load_profiles
    CSV.foreach(BASE_PATH.join("people.txt")) do |row|
      attrs = Hash[PROFILE_FIELDS.zip(row)]
      puts attrs
      p = Profile.new(attrs)
      if !p.save()
        puts "Error saving row: #{row}"
      end
    end
  end

  def CieseDb.load_programs
    CSV.foreach(BASE_PATH.join("newprograms.txt")) do |row|
    end
  end

  def CieseDb.load_activities
    CSV.foreach(BASE_PATH.join("activities.txt")) do |row|
    end
  end

end