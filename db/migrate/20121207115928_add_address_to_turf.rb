class AddAddressToTurf < ActiveRecord::Migration
  def change
    add_column :turfs, :address, :string

  end
end
