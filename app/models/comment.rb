class Comment < ActiveRecord::Base
		
  attr_accessible :content
  
  #a submember of post and user
  belongs_to :post
  belongs_to :user

#  validates :relationship, :presence => true
  validates :user_id, :presence => true
  validates :post_id, :presence => true
  validates :content, :presence =>true

  default_scope :order => 'comments.created_at DESC'
end
