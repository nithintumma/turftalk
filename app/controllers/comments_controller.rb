class CommentsController < ApplicationController
  #list of before filters
  before_filter :authenticate, :setup
  respond_to :html, :js

  #creates a new comment based on params
  def new
    @comment = Comment.new(params[:comment])
  end

  #blank, but can be filled with functions for comments (such as search)
  def index
  end

  #creates a new comment based on a user and a post, as well as building from passed params
  def create
    @user = current_user

    @post = Post.find_by_id(params[:comment][:post_id_value])

    @comment = @post.comments.build(:content => params[:comment][:content])
    @comment.user = current_user
    
    if @comment.save
      flash[:success] = "Comment created!"
      respond_with(@comment)    
    else
      flash[:error] = "Comment not created :("
    end
  end

  #can be used down the line to delete a comment
  def destroy
  end

  protected
    #setup for getting the current turf and user if available, called as a before filter
    def setup      
      @post = Post[params[:post_id]] if params[:post_id]
      @user = current_user
    end
end
