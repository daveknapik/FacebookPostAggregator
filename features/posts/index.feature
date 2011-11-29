Feature: List posts
  In order to see a Facebook user's activity
  As a user
  I want to list a Facebook user's posts

@wip
Scenario: Visit a Facebook user's posts index
  Given there is a Facebook user with posts
  When I go to that Facebook user's posts index page
  Then I should see a list of posts