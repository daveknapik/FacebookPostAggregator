class PostsController < ApplicationController
  def index
    @graph = get_graph
    @facebook_user = FacebookUser.find_by_username(params[:facebook_user_id])
    
    if @facebook_user.posts.count > 0
      #get posts since last import and update posts table with these posts
      #, :since => @facebook_user.posts.first.created_at.to_i
      posts = []
    else
      posts = @graph.get_connections(@facebook_user.fb_id,'posts')
    end 
    
    posts.each do |p|
      post = @facebook_user.posts.build(:title => p['message'] ? p['message'] : p['story'],
                                        :comment_count => p['comments']['count'],
                                        :fb_id => p['id'].split('_')[1],
                                        :fb_created_at => p['created_time'])
      post.save
    end
  end
end
