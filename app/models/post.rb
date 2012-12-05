class Post < ActiveRecord::Base
  attr_accessible :content
  belongs_to :turf
  belongs_to :user

#  validates :relationship, :presence => true
  validates :user_id, :presence => true
  validates :turf_id, :presence => true
  validates :content, :presence =>true

  default_scope :order => 'posts.created_at DESC'
end
