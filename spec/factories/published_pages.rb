FactoryGirl.define do
  factory :published_page do
    url { page.url }
    association :page, strategy: :build
    association :user, strategy: :build
  end
end

