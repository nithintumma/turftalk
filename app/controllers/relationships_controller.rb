class RelationshipsController < ApplicationController

  #creates a new relationship, which is a model assocating a turf and a user
  #it expands on the previously mentioned following-followed relationship between 
  #users and turf
  #this is used in JOINING a turf
  def create
    @turf = Turf.find(params[:relationship][:followed_id])
    cookies[:current_turf_location][:latitude] = @turf.latitude
    cookies[:current_turf_location][:longitude] = @turf.longitude
    if(!current_user.following?(@turf))
      current_user.follow!(@turf)
      respond_to do |format|
        format.html { redirect_to @turf }
        format.js
      end
    else
      redirect_to @turf
    end    
  end

  #destroys the relationship between a user and a turf
  #this is used in LEAVING a turf
  def destroy
    @turf = Relationship.find(params[:id]).followed
    current_user.unfollow!(@turf)
    respond_to do |format|
      format.html { redirect_to "/users" }
      format.js
    end
  end

end
