class TurfsController < ApplicationController
before_filter do
    :authenticate  
  end
  
  #shows a given turf, based on finding it by the given id
  #also performs the VERY IMPORTANT steps of location and following verification.
  #In this method, we follow a turf if it's in range and not already being followed
  def show
    @turf = Turf.find(params[:id])
    if(!current_user.following?(@turf) && in_range(@turf))
      current_user.follow!(@turf)
    end

    @title = in_range(@turf)
    @posts = @turf.posts
    @post = Post.new if signed_in?

    @chats = @turf.chats
    @chat = Chat.new if signed_in?
  end

  #allows a new turf
  def new
	@title = "Create New Turf"
	@turf = Turf.new
  end
  
  #creates a new turf, and stores the lat long and accuracy based on the current used values
  def create
    @turf = Turf.new(params[:turf])
    @turf.latitude = get_location_latitude
    @turf.longitude = get_location_longitude
    @turf.accuracy = get_location_accuracy
    
    if @turf.save
      # Handle a successful save.
      flash[:success] = "Thanks for creating the turf!"
      redirect_to @turf
    else
      @title = "Create New Turf"
      render 'new'
    end
  end
  
  #the compliment to the user "following" function, delineating the user-turf relationshiop
  #this shows the users currently in a turf
  def followers
	@turf = Turf.find(params[:id])
    @title = "Followers of " + @turf.name
    @users = @turf.followers
    render 'show_follow'
  end

  




end
