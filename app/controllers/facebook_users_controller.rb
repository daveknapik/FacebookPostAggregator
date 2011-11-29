class FacebookUsersController < ApplicationController
  def index
  end

  def show
    begin
      @facebook_user = FacebookUser.find_on_facebook(get_graph,params[:id])
    rescue Koala::Facebook::APIError => e
      if e.message.include? "expired"
        flash[:error] = 'Your session had expired. Please try your last search again now.'
        redirect_to oauth.url_for_oauth_code(:permissions => :read_stream)
      else
        flash[:error] = 'We were unable to find a user by the name of "' + params[:id] + '"'
        redirect_to facebook_users_path
      end
    end
  end

  def search
    unless params[:facebook_user][:name].blank?
      begin
        @facebook_user = FacebookUser.find_on_facebook(get_graph,params[:facebook_user][:name])
      rescue Koala::Facebook::APIError => e
        if e.message.include? "expired"
          flash[:error] = 'Your session had expired. Please try your last search again now.'
          redirect_to oauth.url_for_oauth_code(:permissions => :read_stream)
        else
          flash[:error] = 'We were unable to find a user by the name of "' + params[:facebook_user][:name] + '"'
          redirect_to facebook_users_path
        end
      end
    else
      flash[:error] = "You must provide a search term"
      redirect_to facebook_users_path
    end
  end
end
