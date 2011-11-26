class FacebookUsersController < ApplicationController
  before_filter :get_graph

  def index
  end

  def show
    @results = @graph.get_connections(params[:id],'posts')
  end

  def search
    unless params[:facebook_user][:name].blank?
      user_from_facebook_api = @graph.get_object(params[:facebook_user][:name])
      user_in_database = FacebookUser.find_by_fb_id(user_from_facebook_api['id'])

      if user_in_database
        @facebook_user = user_in_database
      else
        @facebook_user = FacebookUser.new(:name => user_from_facebook_api['name'], 
                                          :fb_id => user_from_facebook_api['id'])
        @facebook_user.save
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
