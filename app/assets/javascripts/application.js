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

$(document).ready(function(){
	
	history.replaceState({container: $("#main.container").html() }, null, document.location.href);
	
	$("a:not('.no_ajax'),").live('click', function() { 
		site = 	$(this).attr('href');
		queryString = parseQueryString(site);
		queryString.empty = "true";
		
		$.ajax($(this).attr("href"), {dataType: "html", type: "GET", data: queryString,
			success: function(data) { 
				$("#main.container").html(data); //,
				// $(location).attr('href', "#"+site),
				history.pushState({container: $("#main.container").html() }, null, site);
			}
		});
		return false;
	});
		
	$(window).bind('popstate', function(event) {
    // if the event has our history data on it, load the page fragment with AJAX
    var state = event.originalEvent.state;
    if (state) {
        // container.load(state.path);
			$("#main.container").html(state.container);
    }
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
$(document).ready(function() { 
	sortingColumns();	
});

$(document).ready(function(){
	
	$("#to").autocomplete({
			source: function(req, add){
				if(add.size == 1)
				{
					$.ajax({
						url: "/searches"
					});
				}
				else if (add.size > 1)
				{

				}

				$.getJSON("calls.js", req, function(data){
					var suggestions = [];

					$.each(data, function(i,val){
						suggestions.push(val.name);
					});

					add(suggestions);
				});
			}
	});
	
});


function repaintPage(val) {
	
}

function parseQueryString(text) {
  var nvpair = {};
  var qs = text.replace(/^.+\?/, '');
  var pairs = qs.split('&');
  $.each(pairs, function(i, v){
    var pair = v.split('=');
    nvpair[pair[0]] = pair[1];
  });
  return nvpair;
}


