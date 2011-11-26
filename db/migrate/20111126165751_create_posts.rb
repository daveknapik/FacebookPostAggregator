class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :fb_created_at
      t.string :title
      t.integer :comment_count

      t.references :facebook_user
      t.timestamps
    end

    execute "ALTER TABLE posts ADD COLUMN fb_id bigint"
  end
end
