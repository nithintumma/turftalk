class CreateChat < ActiveRecord::Migration
  def up
  	create_table :chats do |t|
      t.string :content

      t.integer :relationship_id
      t.integer :user_id
      t.integer :turf_id

      t.timestamps
    end
    add_index :posts, [:user_id, :turf_id, :created_at]

  end

  def down
  end
end
