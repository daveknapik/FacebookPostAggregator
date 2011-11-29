class FacebookUser < ActiveRecord::Base
  has_many :posts

  def self.find_on_facebook(graph,username)
    user_from_facebook_api = graph.get_object(username)
    user_in_database = FacebookUser.find_by_fb_id(user_from_facebook_api['id'])

    if user_in_database
      user_in_database
    else
      facebook_user = FacebookUser.new(:name => user_from_facebook_api['name'], 
                                       :fb_id => user_from_facebook_api['id'],
                                       :username => user_from_facebook_api['username'],
                                       :link => user_from_facebook_api['link'])
      facebook_user.save
      facebook_user
    end
  end
end
