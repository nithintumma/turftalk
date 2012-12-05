class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  has_many :posts

  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "Turf"

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
