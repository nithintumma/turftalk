class AddDetailsToTurf < ActiveRecord::Migration
  def change
    add_column :turfs, :latitude, :string
    add_column :turfs, :longitude, :string
    add_column :turfs, :accuracy, :string
  end
end
