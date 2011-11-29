require 'spec_helper'

describe PostsController do
  describe "#index" do
    before(:each) do
      controller.class.skip_before_filter :check_access_token
      @graph = Koala::Facebook::API.new
    end

    context "Facebook API call returns posts" do
      before(:each) do
        post = {"id"=>"528995148_10150478137635149", "from"=>{"name"=>"Dave Knapik", "id"=>"528995148"}, "story"=>"Dave Knapik changed his Website.", "story_tags"=>{"0"=>[{"id"=>528995148, "name"=>"Dave Knapik", "offset"=>0, "length"=>11}]}, "actions"=>[{"name"=>"Comment", "link"=>"http://www.facebook.com/528995148/posts/10150478137635149"}, {"name"=>"Like", "link"=>"http://www.facebook.com/528995148/posts/10150478137635149"}], "type"=>"status", "created_time"=>"2011-11-27T15:33:46+0000", "updated_time"=>"2011-11-27T15:33:46+0000", "comments"=>{"count"=>0}}
        @posts = Array.new
        5.times {@posts << post}

        @graph.stub(:get_connections).and_return(@posts)
        controller.stub(:get_graph).and_return(@graph)
        
        @facebook_user = Factory.create(:facebook_user_with_posts)
        FacebookUser.stub(:find_by_username).and_return(@facebook_user)
      end

      it "should save new posts" do
        old_post_count = @facebook_user.posts.count
        post_count_from_api_call = @posts.count
        get :index, :facebook_user_id => @facebook_user.username
        @facebook_user.posts.count.should == old_post_count + post_count_from_api_call
      end
    end
  end
end
