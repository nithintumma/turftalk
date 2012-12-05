class UpdatePosts2 < ActiveRecord::Migration
  def up
  	create_table :posts do |t|
      t.string :content

      t.integer :relationship_id

      t.timestamps
    end
    add_index :posts, [:relationship_id, :created_at]
  end

  def down
  end
end
