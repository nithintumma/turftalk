class CreateVotes < ActiveRecord::Migration
  def up
  	create_table :votes do |t|
		t.integer :user_id
		t.integer :post_id
		t.boolean :up

      t.timestamps
    end
  end

  def down
  end
end
