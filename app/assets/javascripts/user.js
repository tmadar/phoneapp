function updateContactOfAgent(user_id, new_state) {
	user_url = "/users/" + user_id + ".json"
	request = $.ajax({
		url: user_url,
		type: 'PUT',
		dataType: 'json',
		data: { user: {means_of_contact: new_state} },
		success: function(data) {
			$("#user_" + user_id + "_contact").html(new_state + ' <b class="caret"></b>');
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
			$("#user_" + user_id + "available").html(new_state + ' <b class="caret"></b>');
		}
	});
}