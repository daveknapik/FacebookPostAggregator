# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :facebook_user do
    fb_id "528995148"
    name "Dave Knapik"
    username "daveknapik"
    link "http://www.facebook.com/daveknapik"
  end

  factory :facebook_user_with_posts, :parent => :facebook_user do
    after_create do |facebook_user| 
      3.times {Factory(:post, :facebook_user => facebook_user)}
    end
  end
end
