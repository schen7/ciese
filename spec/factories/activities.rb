FactoryGirl.define do
  factory :activity do
    ignore do
      program_obj { Program.any? ? Program.order("RANDOM()").take : build(:program) }
    end

    association :profile, strategy: :build
    program { program_obj.name }
    detail { program_obj.details.sample }
    start_date { 2.weeks.ago }
    end_date { 1.week.ago }
  end
end
