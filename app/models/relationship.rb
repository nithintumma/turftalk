class Relationship < ActiveRecord::Base
  #accessible elements
  attr_accessible :followed_id

  #associations with many posts
  has_many :posts

  #a submember of both follower and follweod classes
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "Turf"

  #presence validation
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
