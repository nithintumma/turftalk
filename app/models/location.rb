class Location < ActiveRecord::Base
  #accessible attributes
  attr_accessible :accuracy, :latitude, :longitude, :address, :user_id

  
end
