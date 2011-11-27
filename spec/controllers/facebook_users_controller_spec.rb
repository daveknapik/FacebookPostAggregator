require 'spec_helper'

describe FacebookUsersController do
  describe "#search" do
    before(:each) do
      controller.class.skip_before_filter :check_access_token
      @graph = Koala::Facebook::API.new
    end

    context "user exists on Facebook" do
      before(:each) do
        @graph.stub(:get_object).and_return({"id"=>"528995148", "name"=>"Dave Knapik", "first_name"=>"Dave", "last_name"=>"Knapik", "link"=>"http://www.facebook.com/daveknapik", "username"=>"daveknapik", "gender"=>"male", "timezone"=>-5, "locale"=>"en_GB", "verified"=>true, "updated_time"=>"2011-10-25T11:28:52+0000"})
        controller.stub(:get_graph).and_return(@graph)
      end
      
      it "should assign facebook_user" do
        get :search, :facebook_user => {:name => "daveknapik"}
        assigns(:facebook_user).username.should == "daveknapik"
        assigns(:facebook_user).name.should == "Dave Knapik"
      end

      it "should save the facebook_user to the database if it isn't already there" do
        get :search, :facebook_user => {:name => "daveknapik"}
        facebook_user = FacebookUser.find_by_username(assigns(:facebook_user).username)
        facebook_user.should_not be_nil
        facebook_user.should be_a FacebookUser
      end

      it "should not save the facebook_user to the database if it already exists" do
        #Factory.create(:facebook_user, :name => "daveknapik")
        get :search, :facebook_user => {:name => "daveknapik"}
        get :search, :facebook_user => {:name => "daveknapik"}
        FacebookUser.all.count.should == 1
      end
    end

    context "user does not exist on Facebook" do
      before(:each) do
        @graph.stub(:get_object).and_raise(Koala::Facebook::APIError)
        controller.stub(:get_graph).and_return(@graph)
        get :search, :facebook_user => {:name => "wuhwhguavscnwkenn88saiqqb"}
      end

      it "should not assign facebook_user" do
        assigns(:facebook_user).should be_nil
      end

      it "should not save the facebook_user to the database" do
        facebook_user = FacebookUser.find_by_username("wuhwhguavscnwkenn88saiqqb")
        facebook_user.should be_nil
      end

      it "should set an error in the flash" do
        flash[:error].should_not be_nil
      end

      it "should redirect to facebook_users_path" do
        response.should redirect_to facebook_users_path
      end
    end
  end
end