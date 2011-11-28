# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    fb_id "563992201"
    title "I ate some cheese and it was good"
    comment_count 3
    fb_created_at "2011-11-26 11:57:51"
    association :facebook_user, :factory => :facebook_user_with_posts
  end
end
