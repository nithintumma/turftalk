class AddIndexesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :user_id, :integer
    add_column :posts, :turf_id, :integer
  end
end
