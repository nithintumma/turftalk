class Turf < ActiveRecord::Base
  attr_accessible :description, :location, :name

  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  has_many :posts, :dependent => :destroy

  validates :name,  :presence => true,
                    :length   => { :maximum => 255 }

  validates :description,  :presence => true,
                    :length   => { :maximum => 255 }

  validates :location,  :presence => true,
                    :length   => { :maximum => 255 }

end
