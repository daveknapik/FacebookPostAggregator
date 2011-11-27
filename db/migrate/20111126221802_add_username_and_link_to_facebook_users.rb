class AddUsernameAndLinkToFacebookUsers < ActiveRecord::Migration
  def change
    add_column :facebook_users, :username, :string
    add_column :facebook_users, :link, :string
  end
end
