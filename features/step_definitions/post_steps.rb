Given /^there is a Facebook user with posts$/ do
  @facebook_user = Factory.create(:facebook_user_with_posts)
end

When /^I go to that Facebook user's posts index page$/ do
  FacebookUser.stub(:find_on_facebook).and_return(@facebook_user)
  visit facebook_user_posts_path(@facebook_user.username)
end

Then /^I should see a list of posts$/ do
  @facebook_user.posts.each do |post|
    page.should have_content post.title
  end
end