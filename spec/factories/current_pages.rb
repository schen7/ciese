FactoryGirl.define do
  factory :current_page do
    association :version, factory: :page, strategy: :create
    page_id { version.page_id }
  end
end

