# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :facebook_user do
    fb_id "528995148"
    name "Dave Knapik"
    username "daveknapik"
    link "http://www.facebook.com/daveknapik"
  end
end
