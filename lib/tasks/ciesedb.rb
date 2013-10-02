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
      row = row.map do |item|
        item.sub("\\N", "")
      end
      attrs = Hash[PROFILE_FIELDS.zip(row)]
      p = Profile.new(attrs)
      if !p.save()
        puts "Error saving row: #{row}"
      end
    end
  end

  def CieseDb.load_programs
    programs = {}
    CSV.foreach(BASE_PATH.join("newprograms.txt")) do |row|
      row = row.map do |item|
        item.sub("\\N", "")
      end
      id, name, detail = row
      if !programs.has_key?(id)
        programs[id] = {id: id, name: name, details: [detail]}
      else
        programs[id][:details].push(detail)
      end
    end
    programs.each do |id, program|
      p = Program.new(program)
      if !p.save()
        puts "Error saving row: #{program}"
      end
    end
  end

  def CieseDb.load_activities
    CSV.foreach(BASE_PATH.join("newactivities.txt")) do |row|
      attrs = Hash[ACTIVITY_FIELDS.zip(row)]
      unless attrs[:start_date].to_i == 0
        attrs[:start_date] = Date.strptime(attrs[:start_date], '%s')
      end
      unless attrs[:end_date].to_i == 0
        attrs[:end_date] = Date.strptime(attrs[:end_date], '%s')
      end
      a = Activity.new(attrs)
      if !a.save()
        puts "Error saving row: #{row}"
      end
    end
  end

  def CieseDb.load_all
    CieseDb.load_profiles
    CieseDb.load_programs
    CieseDb.load_activities
  end

end