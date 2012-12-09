class Chat < ActiveRecord::Base
	
  attr_accessible :content
  belongs_to :turf
  belongs_to :user

#  validates presence
  validates :user_id, :presence => true
  validates :turf_id, :presence => true
  validates :content, :presence =>true

  #orders by created time by defaults
  default_scope :order => 'chats.created_at DESC'
end
