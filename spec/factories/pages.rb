FactoryGirl.define do
  factory :page do
    sequence(:url) { |n| "/url/page#{n}" }
    sequence(:title) { |n| "Title #{n}" }
    page_id nil
    content ""
    association :user, strategy: :build
  end
end
