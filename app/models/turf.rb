class Turf < ActiveRecord::Base
  #accessible and settable parameters
  attr_accessible :description, :location, :name, :latitude, :longitude, :address

  #users reverse_relationships to define the followeing-follower relationships based
  #on symmetry within a single table
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  #owns many posts
  has_many :posts, :dependent => :destroy

  #owns many chats
  has_many :chats, :dependent => :destroy

  #validations for presence
  validates :name,  :presence => true,
                    :length   => { :maximum => 255 }

  validates :location,  :presence => true,
                    :length   => { :maximum => 255 }

#  searchable do
#    text :name, :default_boost => 2
#    text :description
#  end

  #uses the geocoding API
  reverse_geocoded_by :latitude, :longitude, :address => :location
  after_validation :reverse_geocode, :if => (:latitude_changed? && :longitude_changed?)

  #defines the search function based on both name and location similarity
  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

end
