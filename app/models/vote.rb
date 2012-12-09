class Vote < ActiveRecord::Base
	attr_accessible :up, :post_id, :user_id

	#a vote is a property of both a user and a class
	belongs_to :user
	belongs_to :post

	#checks that there is only one given vote for each user-id pair
	validates :user_id, :uniqueness => { :scope => :post_id }

end