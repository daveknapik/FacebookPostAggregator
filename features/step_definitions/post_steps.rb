Given /^there is a Facebook user with posts$/ do
  @facebook_user = Factory.create(:facebook_user_with_posts)
end

When /^I go to that Facebook user's posts index page$/ do
  visit facebook_user_posts_path(@facebook_user.username)
end

Then /^I should see a list of posts$/ do
  @facebook_user.posts.each do |post|
    page.should have_link(post.title, :href => "http://www.facebook.com/#{@facebook_user.username}/posts/#{post.fb_id}")
  end
end