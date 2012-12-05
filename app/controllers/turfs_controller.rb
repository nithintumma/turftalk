class TurfsController < ApplicationController
  def show
    @turf = Turf.find(params[:id])
    @title = @turf.name
    @posts = @turf.posts
    @post = Post.new if signed_in?
  end

  def new
	@title = "Create New Turf"
	@turf = Turf.new
  end
  
  def create
    @turf = Turf.new(params[:turf])
    if @turf.save
      # Handle a successful save.
      flash[:success] = "Thanks for creating the turf!"
      redirect_to @turf
    else
      @title = "Create New Turf"
      render 'new'
    end
  end
  
  def followers
	@turf = Turf.find(params[:id])
    @title = "Followers" + @turf.name
    @users = @turf.followers
    render 'show_follow'
  end

end
