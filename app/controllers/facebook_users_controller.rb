class FacebookUsersController < ApplicationController
  def index
  end

  def show
    @graph = get_graph
    @results = @graph.get_connections(params[:id],'posts')
  end

  def search
    unless params[:facebook_user][:name].blank?
      @graph = get_graph
      begin
        user_from_facebook_api = @graph.get_object(params[:facebook_user][:name])
        user_in_database = FacebookUser.find_by_fb_id(user_from_facebook_api['id'])

        if user_in_database
          @facebook_user = user_in_database
          #new_posts = @graph.get_connections(@facebook_user.fb_id,'posts', :since => @facebook_user.posts.first.created_at.to_i)
          #get posts since last import and update posts table with these posts
        else
          @facebook_user = FacebookUser.new(:name => user_from_facebook_api['name'], 
                                            :fb_id => user_from_facebook_api['id'],
                                            :username => user_from_facebook_api['username'],
                                            :link => user_from_facebook_api['link'])
          @facebook_user.save

          #get posts and save them
        end
      rescue Koala::Facebook::APIError
        flash[:error] = 'We were unable to find a user by the name of "' + params[:facebook_user][:name] + '"'
        redirect_to facebook_users_path
      end
    else
      flash[:error] = "You must provide a search term"
      redirect_to facebook_users_path
    end
  end

  def get_graph
    if session[:access_token]
      @graph ||= Koala::Facebook::API.new(session[:access_token])
    else
      redirect_to oauth.url_for_oauth_code(:permissions => :read_stream) 
    end
  end
end
