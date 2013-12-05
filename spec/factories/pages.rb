FactoryGirl.define do
  factory :page do
    sequence(:url) { |n| "/url/page#{n}" }
    content ""
    association :user, strategy: :build
    latest false
    published false
  end
end

