// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap
//= require_tree .

var refreshTimer;

$(function () {
    $('.popover-comment').popover({ html : true });
});

$(document).ready(function() { 
	$(".nav li a").click(function() { 
	
	site = 	$(this).attr('href');
	
	   $.ajax($(this).attr("href") + "?empty=1", {dataType: "html", type: "GET", 
				success: function(data) { 
					$("#main.container").html(data); //,
					// $(location).attr('href', "#"+site),
					history.pushState(null, null, site);
					allow_agent_sort();
				}
			});

	   return false;

	});
});

function checkActivity() {
	// $.getJSON('/calls/in_progress.js', function(data) {
	// 	var items = [];
	// 	
	// 	$.each(data, function(key, value) {
	// 		items.push("<tr id='inProgressRow_" + value.id +"'><td class=\"bolded\">Callback #</td>" + 
	// 			"<td>" + value.caller + "</td>");
	// 	});
	// 			
	// 	$("#inprogress").html("<h3>Call In Progress</h3>" +
	// 		"<table class=\"table table-bordered table-striped\" id=\"inProgressTable\">" +
	// 		items.join('') + "</table>");
	// 
	// 	if ($(items).size() == 0) {
	// 		$("#inprogress").hide();		
	// 	}
	// 	else {
	// 		$("#inprogress").show();
	// 	}
	// });
	
	$.ajax({
		url: "/calls/in_progress.js",
		dataType: "script"
	});
}

