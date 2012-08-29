function updateContactOfAgent(user_id, new_state) {
	user_url = "/users/" + user_id + ".json"
	request = $.ajax({
		url: user_url,
		type: 'PUT',
		dataType: 'json',
		data: { user: {means_of_contact: new_state} },
		success: function(data) {
			$("#user_" + user_id + "_contact").html(new_state + ' <span class="caret"></span>');
		}
	});
}

function updateAvailabilityOfAgent(user_id, new_state) {
	user_url = "/users/" + user_id + ".json"
	request = $.ajax({
		url: user_url,
		type: 'PUT',
		dataType: 'json',
		data: { user: {availability: new_state} },
		success: function(data) {
			$("#user_" + user_id + "_available").html(new_state + ' <span class="caret"></span>');
		}
	});
}

$(function() {
	$('*[data-modal]').click(function(e) {
   	e.preventDefault();
    var href = $(e.target).attr('href');
    if (href.indexOf('#') == 0) {
    	$(href).modal('hide');
    } else {
    	$.get(href, function(data) {
      	$('<div class="modal">' + data + '</div>').modal('hide').appendTo('body');
      });
    }
  });
});

function displayUser(user_id) {
	$.ajax({url: "/users/" + user_id + ".js", dataType: "script"});
}

function edit_name_field(user_id, property) { 
	$(this).bind('click')
	
	$("td[id='"+property.id+"']").replaceWith("<td><input type=text></td>");
	
	$("th").one('click', function() {
		user_url = "/users/" + user_id + ".json"
		request = $.ajax({
		url: user_url,
		type: 'PUT',
		dataType: 'json',
		data: { user: {name: $("input[type='text']").val()} },
		success: function(data) {
			alert("done");}
		});
		$(this).unbind('click');
	});
	
}

function edit_phone_field(user_id, property) { 
	$(this).bind('click')
	$("td[id='"+property.id+"']").replaceWith("<td><input type=text></td>");
	
	$("th").one('click', function() {
		user_url = "/users/" + user_id + ".json"
		request = $.ajax({
		url: user_url,
		type: 'PUT',
		dataType: 'json',
		data: { user: {phone: $("input[type='text']").val()} },
		success: function(data) {
			alert("done");}
		});
		$(this).unbind('click');
	});
	
}

function edit_email_field(user_id, property) { 
	$(this).bind('click')
	
	$("td[id='"+property.id+"']").replaceWith("<td><input type=text></td>");
	
	$("th").one('click', function() {
		user_url = "/users/" + user_id + ".json"
		request = $.ajax({
		url: user_url,
		type: 'PUT',
		dataType: 'json',
		data: { user: {email: $("input[type='text']").val()} },
		success: function(data) {
			alert("saved");}
		});
		$(this).unbind('click');
	});
	
}

function magic() {
	$("tr[id^='user_'] td.clickable").click(function(event) {
		
		user_id = $(this).parent().attr('id').replace(/user_/, '');
		row_obj = $("tr[id='user_" + user_id + "']");
		
		if ($("#user_" + user_id + " input[type=text]").length == 0) {
			$.ajax("/users/" + user_id + "?edit=1", {dataType: "script"});
			row_obj.attr("edited", "true")
		}
		
		
		$('html').one('click', function(e) {
			if (row_obj.attr("edited") == "true") {
				$.ajax("/users/" + user_id, {type: "PUT", 
					data: $("#user_" + user_id + " input"), 
					error: function(result) {
						$.ajax("/users/" + user_id, { type: "GET", dataType: "script" });
						eval(result.responseText);
					},
					dataType: "script"});
				row_obj.removeAttr("edited");
			}
		});
		
		
		$('#user_' + user_id + ' input:last').live('keydown', function(event) {
		            var keycode = event.keyCode;
		            if (keycode == 9 && ! event.shiftKey ) {
										$("html").click();
		                event.preventDefault();
		            }   
		 });
		
		$('#user_' + user_id + ' form').submit(function() {
			$('html').click();
			return false;
		})
		
		event.stopPropagation();
		
	});
}

function allow_agent_sort() { 
	
	sortableList = $("#users tbody").sortable({items: "tr[id^='user_']", forcePlaceholderSize: true, forceHelperSize: true}).disableSelection();
	
	if (sortableList != null) {
		sortableList.bind("sortupdate", function(event, ui) {
			orderOfUsers = $.map($("tbody").sortable('toArray'), 
				function(val, i) { return parseInt(val.replace(/user_/,'')) });

			request = $.ajax({
					type: 'POST',
					url:"/users/prioritize", 
					data: { 'users' : orderOfUsers },
					success: function() { }
				});
			// POST /users/reset_order?users=[10,8]
			// insert logic where you would send server array of user ids to be put in order
		});
	}
	
	// // Selecting all table rows that have id user_*
	magic();
};
