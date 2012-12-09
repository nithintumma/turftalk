class VotesController < ApplicationController
 	respond_to :html, :js
 	#creates a new vote based on passed parameters (post id) and a certain user id
 	#this uses an interesting model where a vote has only a boolean value (true or false)
 	#specifying up or down
 	def create
	  @vote = Vote.where(:post_id => params[:vote][:post_id], :user_id => current_user.id).first
		@up = params[:vote][:up]
		@id = params[:vote][:post_id]
		respond_with(@vote)

		if @vote
		  @vote.up = params[:vote][:up]
		  @vote.save
		else
		  @vote = current_user.votes.create(params[:vote])
		end
 	end
end