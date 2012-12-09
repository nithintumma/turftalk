// once the document has been loaded, if we are a turf home page call the updatePosts and updateChats with a timer
$(function() {
  if ($(".post-container").length > 0) {
    setTimeout(updatePosts, 3000);
        setTimeout(updateChats, 500);
  }
});
 
// updatePosts sends an AJAX request to the server and evaluates a script on the Post index, calls itself with timer
function updatePosts () {
        var turf_id = $("#current_turf").attr("data-turfid");
        if ($(".post_ind").length > 0) {
        var after = $(".a_post:last-child").attr("data-time");
        } else {
        var after = "0";
        }
        $.getScript("/posts.js?turf_id=" + turf_id + "&after=" + after)
        setTimeout(updatePosts, 2000);
}
 
// updateChats sends an AJAX request to the server and evaluates a script on the Chat index, calls itself with timer
function updateChats() {
        var turf_id = $("#current_turf").attr("data-turfid");
        if ($(".chat-container").length > 0) {
        var after = $(".a_chat:last-child").attr("data-time");
        } else {
        var after = "0";
        }
        $.getScript("/chats.js?turf_id=" + turf_id + "&after=" + after)
        setTimeout(updateChats, 10000);
}