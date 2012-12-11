class UsersController < ApplicationController
  #ensures that users are authenticated and logged in (doesn't actually work yet)
  before_filter(:except => :create) do
    :authenticate  
  end

  #displays any given user based on a given parameters
  def show
    @user = User.find(params[:id])
    @title = @user.firstname
  end

  #creates a new user
  def new
	@title = "Sign Up"
	@user = User.new
  end
  
  #used to display the default page for a logged in user
  #this page displays all of the possible turfs, as well as contains the turf search function
  #this may seem unconventional to place the search in the user index page, but it is because
  #search by turf only occurs in this user show page
  #proper MVC deliniation is still made by calling a partial from within search later
  def index

    @title = "All users"
    @users = User.all
    @results = nil

    if params[:search] != ""
      @results = Turf.search(params[:search])
    end
  end
  
  #shows hte profile for the current user
  def profile
	@user = current_user
	@title = "This is your profile page"
  end
  
  #creates a new user, attempts to save it and sign it in, and includes validation for
  #presence, length, uniqueness, password confirmation, etc
  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      sign_in @user
      flash[:success] = "Welcome to turftalk!"
      redirect_to '/users'
    else
      @title = "Sign up"
      redirect_to root_path, :user => @user

      #we should definitely fix this long term - this should be in a partial, but i can't get it to work right there
      initial_error = "Sorry, errors prohibited this user from being saved, including:"
      errors = [initial_error]

      if @user.errors.any?    
        @user.errors.full_messages.each do |msg|
          errors << msg
        end
        flash[:error] = errors.join("<br/>   - ").html_safe
      end

    end


  end
  
  #relationship between a user "following" a turf (based on twitter models but will
  #be refined and name changed in the future)
  def following
    @user = User.find(params[:id])
    @title = @user.firstname + " Is Following"
    @turfs = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end  
  
end
