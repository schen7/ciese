# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { "#{username}@none.com" }
    password_digest "bad_digest"
    admin false
    staff false
    active true
  end
end
