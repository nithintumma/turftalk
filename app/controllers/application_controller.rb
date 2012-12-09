class ApplicationController < ActionController::Base
  #list of before filters
  protect_from_forgery
  include SessionsHelper
  before_filter :instantiateUser
  before_filter :instantiateTurf
  before_filter :instantiatePost
  before_filter :instantiateComment
  before_filter :instantiateChat

   #creates a user for use in display purposes
  def instantiateUser
    @user = User.new
  end

  #creates a turf for use in display purposes
  def instantiateTurf
    @turf = Turf.new
  end

  #creates a post for use in display purposes
  def instantiatePost
    @post = Post.new
  end

  #creates a comment for use in display purposes
  def instantiateComment
    @comment = Comment.new
  end

  #creates a chat for use in display purposes
  def instantiateChat
    @chat = Chat.new
  end


end
