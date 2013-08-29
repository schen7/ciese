class ActivitySerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :program_name, :detail, :start_date, :end_date
  has_one :program

  def program_name
    program.name
  end
end
