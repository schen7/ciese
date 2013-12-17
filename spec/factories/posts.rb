# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    topic_id 1
    title "My_title"
    content "My_content"
    author 1
  end
end
