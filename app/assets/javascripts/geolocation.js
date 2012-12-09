//called upon document loat
$(function (){
 
        var watchID;
        var geoLoc;
        
        //callback; takes position from geolocator and sends an AJAX post request of a location JSON
        //to the server
        function showLocation(position) {
          var latitude = position.coords.latitude;
          var longitude = position.coords.longitude;
          //alert("Latitude : " + latitude + " Longitude: " + longitude);
                //alert("about to send AJAX form");
                $.post("/locations.json",
                {
                	location:
                                {
                                        latitude: position.coords.latitude,
                                        longitude: position.coords.longitude,
                                        accuracy: position.coords.accuracy
                                }
                }
                        );
        }
        
        //callback that can display errors if the user does not support geolocation
        function errorHandler(err) {
          if(err.code == 1) {
            alert("Error: Access is denied!");
          }else if( err.code == 2) {
            alert("Error: Position is unavailable!");
          }
        }
 
   //testing to see if geolocation is available, in which case it calls the watch position function
   //which monitors position and calls the show location callback based on user movement
   //if not available, we get an alert saying geolocation not supported
   if(navigator.geolocation){
      // timeout at 60000 milliseconds (60 seconds)
      var options = {timeout:100, enableHighAccuracy: true};
      geoLoc = navigator.geolocation;
      watchID = geoLoc.watchPosition(showLocation,
                                     errorHandler,
                                     options);
   }else{
      alert("Sorry, browser does not support geolocation!");
   }
 
});