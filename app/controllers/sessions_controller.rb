class SessionsController < ApplicationController
  #allows a new session for a currently signed in user
  def new
    @title = "Sign in"
  end

  #creates a new session as a user is signed in, adding them to the user table
  #this also performs authentication on the email and password, redirecting if incorrect
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      redirect_to root_path
      flash[:error] = "Invalid email/password combination."
      @title = "Sign in"
      
    else
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to '/users'
    end
  end

  #will allow us to destroy a current session and thus sign a user out
  def destroy
    sign_out
    redirect_to root_path
  end
end
