# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { "#{username}@none.com" }
    password_digest "bad_digest"
    password "appropriate_password"
    password_confirmation "appropriate_password"
    admin false
    staff false
    active true
  
    factory :staff do
      staff true
    end

    factory :admin do
      admin true
    end
  end
end
