class CreateTurfs < ActiveRecord::Migration
  def change
    create_table :turfs do |t|
      t.string :name
      t.string :location
      t.string :description

      t.timestamps
    end
  end
end
