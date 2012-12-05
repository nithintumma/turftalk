class UsersController < ApplicationController
   before_filter :authenticate, :only => [:index, :edit, :update]
  
  def show
    @user = User.find(params[:id])
    @title = @user.firstname
  end

  def new
	@title = "Sign Up"
	@user = User.new
  end
  
  def index
    @title = "All users"
    @users = User.all
  end
  
  def profile
	@user = current_user
	@title = "This is your profile page"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to '/users'
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def following
    @user = User.find(params[:id])
    @title = @user.firstname + " Is Following"
    @turfs = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  private
	def authenticate
      deny_access unless signed_in?
    end

end
