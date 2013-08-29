FactoryGirl.define do
  factory :activity do
    association :profile, strategy: :build
    association :program, strategy: :build
    detail { program.details.sample }
    start_date { 2.weeks.ago }
    end_date { 1.week.ago }
  end
end
