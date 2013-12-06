# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    topic_id 1
    title "MyString"
    content "MyText"
    author 1
  end
end
