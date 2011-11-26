class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_access_token
  helper_method :oauth

  def check_access_token
    session[:access_token] = oauth.get_access_token(params[:code]) if params[:code]
    
    if session[:access_token].blank?
      redirect_to oauth.url_for_oauth_code(:permissions => :read_stream)
    end
  end

  def oauth
    @oauth ||= Koala::Facebook::OAuth.new(Facebook::CALLBACK_URL)
  end
end
