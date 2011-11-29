class PostsController < ApplicationController
  def index
    @graph = get_graph
    begin
      @facebook_user = FacebookUser.find_on_facebook(@graph,params[:facebook_user_id])
    rescue Koala::Facebook::APIError => e
      if e.message.include? "expired"
        flash[:error] = 'Your session had expired. Please try your last search again now.'
        redirect_to oauth.url_for_oauth_code(:permissions => :read_stream)
      else
        flash[:error] = 'We were unable to find a user by the name of "' + params[:facebook_user_id] + '"'
        redirect_to facebook_users_path
      end
    end
    
    if @facebook_user.posts.count > 0
      #get posts since last import and update posts table with these posts
      #, :since => @facebook_user.posts.first.created_at.to_i
      posts = @graph.get_connections(@facebook_user.fb_id,'posts', :since => @facebook_user.posts.order("fb_created_at DESC").first.fb_created_at.to_i)
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
