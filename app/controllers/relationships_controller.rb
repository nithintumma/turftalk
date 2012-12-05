class RelationshipsController < ApplicationController
 
  def create
    @turf = Turf.find(params[:relationship][:followed_id])
    current_user.follow!(@turf)
    respond_to do |format|
      format.html { redirect_to @turf }
      format.js
    end
  end

  def destroy
    @turf = Relationship.find(params[:id]).followed
    current_user.unfollow!(@turf)
    respond_to do |format|
      format.html { redirect_to @turf }
      format.js
    end
  end
end
