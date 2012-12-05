class PostsController < ApplicationController
  before_filter :authenticate, :setup

  def new
    @post = Post.new(params[:post])
  end

  def index
  end

  def create
    @user = current_user
    logger.debug("Now printing user")
    logger.debug(@user)
    @turf = Turf.find_by_id(params[:post][:turf_id_value])
    logger.debug("Now printing turf")
    logger.debug(@turf)

    @post = @turf.posts.build(:content => params[:post][:content])
    @post.user = current_user
    if @post.save
      flash[:success] = "Post created!"
      redirect_to(:back)
    else
      flash[:failure] = "Post not created :("
      redirect_to(:back)
    end
  end

  def destroy
  end

  protected
    def setup      
      @turf = Turf[params[:turf_id]] if params[:turf_id]
      @user = current_user
    end
end
