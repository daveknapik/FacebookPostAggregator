class CreateFacebookUsers < ActiveRecord::Migration
  def change
    create_table :facebook_users do |t|
      t.string :name

      t.timestamps
    end

    execute "ALTER TABLE facebook_users ADD COLUMN fb_id bigint"
  end
end
