$(function () {
	var join_div = $("#join");
	if (join_div.length > 0) 
	{
		if (join_div.attr("data-refresh") == "false")
		{
			$.getScript("turfs.js");
		}
	}
});	

// users/index 