class Post < ActiveRecord::Base
  #sets attributes	
  attr_accessible :content
  
  #a post belongs to both a user as a creator and a turf as a location
  belongs_to :turf
  belongs_to :user

  #owns many comments and votes
  has_many :comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy

#  validates :relationship, :presence => true
  validates :user_id, :presence => true
  validates :turf_id, :presence => true
  validates :content, :presence =>true

  default_scope :order => 'posts.created_at DESC'
end
