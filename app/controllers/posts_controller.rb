class PostsController < ApplicationController
  before_filter :authenticate, :setup
  respond_to :html, :js

  #shows a given post based on its parameters, comments, and new comment field
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new if signed_in?
  end

  #allows a new post based on parameters, given comments for a post, and new comments
  def new
    @post = Post.new(params[:post])
    @comments = @post.comments
    @comment = Comment.new if signed_in?
  end

  #can be used to refresh posts
  def index
    @posts = Post.where("turf_id = ? and created_at > ?", params[:turf_id], Time.at(params[:after].to_i + 1000))
    respond_with(@posts)
  end

  #creates and attempts to save a new post based on a user and a turf id value passed in
  #from a turf form
  def create
    @user = current_user
    @turf = Turf.find_by_id(params[:post][:turf_id_value])

    @post = @turf.posts.build(:content => params[:post][:content])
    @post.user = current_user

    if @post.save
      respond_with(@post)
      flash[:success] = "Post created!"      
    else
      flash[:error] = "Post not created :("
    end
  end

  #can be used to destroy a post down the line
  def destroy
    @post = Post.find(params[:id])
    
    @turf = Turf.find_by_id(@post.turf_id)
    
    if @post.user_id == current_user.id
      if @post.destroy
        flash[:success] = "Post destroyed!" 
        redirect_to(@turf)     
      else
        flash[:error] = "Sorry, post not destroyed"
      end
    else
      flash[:error] = "Sorry, you don't have permission to destroy that post"
    end
  end

  protected
    #initializes the current turf and user based on params and current logged in user
    def setup      
      @user = current_user
    end
end
