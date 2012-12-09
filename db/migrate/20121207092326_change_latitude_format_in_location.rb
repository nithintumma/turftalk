class ChangeLatitudeFormatInLocation < ActiveRecord::Migration
  def up
  	   change_column :locations, :latitude, :float
 	   change_column :locations, :longitude, :float

  end

  def down
  	   change_column :locations, :latitude, :integer
  	   change_column :locations, :longitude, :integer


  end
end
