# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    fb_id ""
    title "MyString"
    comment_count 1
    fb_created_at "2011-11-26 11:57:51"
  end
end
