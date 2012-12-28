module SessionsHelper

  #defines constants used in the Haversine formula for distance
  RAD_PER_DEG = 0.017453293  #  PI/180
  Rmiles = 3956           # radius of the great circle in miles
  Rkm = 6371              # radius in kilometers...some algorithms use 6367
  Rfeet = Rmiles * 5282   # radius in feet
  Rmeters = Rkm * 1000    # radius in meters
  
  #defines a given location string as a fallback alternative
  Location_string = "0 0 0"

  #signs in a user by creating a new session, and also has important location functions
  #upon sign in ,the initial position of a user is saved, and updated by being saved in 
  #current_location for later access and update
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user

    self.current_location = Location.find_by_user_id(user.id)
    if(self.current_location.nil?)
      self.current_location = Location.new(:user_id => user.id, :latitude => 0, :longitude => 0, :accuracy => 100)
    end

    self.current_location.save()
    @current_location = self.current_location
    @current_location.save()
  end

  #specifies setting a current user based on a given user
  def current_user=(user)
    @current_user = user
  end
  
  #returns the current user or from a given "remember token"
  def current_user
    @current_user ||= user_from_remember_token
  end

  #defines setting the current location based on a given location
  def current_location=(location)
    @current_location = location
  end

  #returns the given instance variable location
  def current_location
    @current_location
  end

  #checks if current_user has been set; if it is non-null, we have a current user signed in
  def signed_in?
    !current_user.nil?
  end

  #authenticates as a before filter, denying access to users not signed in
  def authenticate
    deny_access unless signed_in?
  end

  #user as a helper class to verify that the user is in range of each of the turfs that
  #they are currently in
  def verify
    @location = Location.find_by_user_id(current_user.id)
    @current_location = @location

    @turfs = Relationship.find_by_follower_id(current_user.id)

    @turfs.each do |turf|
      in_range(turf)
    end
  end  

  #removes a user from the current session, signing them out
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  #denies access to a given user, redirecting them to the home page and flashing an error message
  #this before filter is not yet implemented fully, but this bug will be fixed soon
  def deny_access
    redirect_to root_path, :notice => "Please log in or sign up to access this page."
  end

  #retuns a given location string
  def get_location_string
    return Location_string
  end

  #returns the current latitude of a given user's location
  def get_location_latitude
    @current_location = Location.find_by_user_id(current_user.id)
    Rails.logger.debug "In latitude function, location is now #{@current_location.inspect}."

    return @current_location.latitude
  end

  #returns the current longitude of a given user's location
  def get_location_longitude
    @current_location = Location.find_by_user_id(current_user.id)
    return @current_location.longitude
  end

  #returns the current accuracy of a given user's location
  def get_location_accuracy
    @current_location = Location.find_by_user_id(current_user.id)
    return @current_location.accuracy
  end

  #an actionaable test if a user is in range of all of the spaces they are currently in
  #this method checks if the user is in range based on the formula 
  #(distance between user and space - accuracy of user location - accuracy of turf location
  # - given radius); if the calculated delta is less than 0, then the user is allowed to remain
  #the space. An important feature is that the function will force users to "leave" spaces they
  #are no longer in range for, but will only redirect back to the home page in the case of
  #the user being out of location of the current specified space
  def in_range(space)
    radius = 50

    #gets list of all turfs that the user is in
    @current_relationships = Relationship.where("follower_id = '#{current_user.id}'")
    Rails.logger.debug "In range function, list is now #{@current_turfs.inspect}."


    @current_relationships.each do |relationship|    
      turf = Turf.find_by_id(relationship.followed_id) 
      Rails.logger.debug "In loop, turf is now #{turf.inspect}."
      distance = haversine_distance(get_location_latitude, get_location_longitude, turf.latitude, turf.longitude)

      if((distance - radius - Integer(turf.accuracy) - get_location_accuracy)<0)        
      else
        #backdoor for admin
        if current_user.email != "admin@turftalk.us"
          flash[:error] = "Sorry, you're no longer in range for " + turf.name + " anymore, so you've been removed."
          if(current_user.following?(turf))
            current_user.unfollow!(turf)
          end

          #checks if we're in the removed turf right now; if so, sends us back to the home directory
          if turf == space
            redirect_to "/users"
          end
        end
      end
    end
  end 

  #very similar to the previous method, but just gives a boolean value of if a user
  # is in range of a given space, without logging out or modifying other spaces
  def silent_in_range(turf)
    #backdoor for admin
    if current_user.email == "admin@turftalk.us"
      flash[:error] = "You're the admin."
      return true
    else  
      radius = 50
      
      distance = haversine_distance(get_location_latitude, get_location_longitude, turf.latitude, turf.longitude)

      if((distance - radius - Integer(turf.accuracy) - get_location_accuracy)<0)        
        return true
      else
        return false
      end    
  end 

  #calculates the distance based on the haversine distance
  def distance_to(turf)
    distance = haversine_distance(get_location_latitude, get_location_longitude, turf.latitude, turf.longitude)
    return distance
  end 

  private

    #reopns a user based on a given topken
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    #token ro remember used
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    #taken from esawdust's ruby implementation found onlinne
    #uses spherical geometry to calculate the Haversine distance between two
    #points in space as given by latitude and longitude
    def haversine_distance( lat1, lon1, lat2, lon2 )
      lat1 = Float(lat1)
      lon1 = Float(lon1)
      lat2 = Float(lat2)
      lon2 = Float(lon2)
      
      dlon = lon2 - lon1
      dlat = lat2 - lat1

      dlon_rad = dlon * RAD_PER_DEG
      dlat_rad = dlat * RAD_PER_DEG

      lat1_rad = lat1 * RAD_PER_DEG
      lon1_rad = lon1 * RAD_PER_DEG

      lat2_rad = lat2 * RAD_PER_DEG
      lon2_rad = lon2 * RAD_PER_DEG

      a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
      c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

      dMi = Rmiles * c          # delta between the two points in miles
      dKm = Rkm * c             # delta in kilometers
      dFeet = Rfeet * c         # delta in feet
      dMeters = Rmeters * c     # delta in meters

      return dMeters
    end

end
