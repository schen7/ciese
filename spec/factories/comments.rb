# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    post_id 1
    content "MyText"
    author 1
  end
end
