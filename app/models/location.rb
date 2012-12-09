class Location < ActiveRecord::Base
  #accessible attributes
  attr_accessible :accuracy, :latitude, :longitude, :user_id, :address

  
end
