class LocationsController < ApplicationController
  before_filter :authenticate, :setup

  #can be used to show a location if need be
  def show    
  end

   #can be used to make, but not save, a new location if need be
  def new
  end

   #can be used to display locations if need be
  def index
  end

  #creates a new location, based on a user's location
  #this method fidns the current user, gets their location from a database, saves it in 
  #a location element, and returns it, making use of javascript to be called in the background
  #and on certain intervals
  def create
    @user = current_user

    @location = Location.find_by_user_id(@user.id)
    if(!@location.nil?)
      @location.latitude = params[:location][:latitude]
      @location.longitude = params[:location][:longitude]
      @location.accuracy = params[:location][:accuracy]
    else
      @location = Location.new(:user_id => @user.id, :latitude => params[:location][:latitude], :longitude => params[:location][:longitude], :accuracy => params[:location][:accuracy])
    end    

    respond_to do |format|
      if @location.save
        format.html { redirect_to "/users", :notice => 'Location was successfully created.' }
        format.json { render :json => "/users", :status => :created, :location => "/users" }
      else
        flash[:error] = "Location NOT saved..."

        format.html { redirect_to "/profile", :notice => 'Location was NOT successfully created.' }
        format.json { render :json => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  #can be used to destroy locations if they are ever permanently saved
  def destroy
  end

  protected 
    #sets up and initializes current user
    def setup      
      @user = current_user
    end
end
