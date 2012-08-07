function updateStateOfCall(call_id, new_state) {
	call_url = "/calls/" + call_id + ".json"
	request = $.ajax({
		url: call_url,
		type: 'PUT',
		dataType: 'json',
		data: { call: {disposition: new_state} },
		success: function(data) {
			$("#call_" + call_id + "_disposition").html(new_state + ' <b class="caret"></b>');
		}
	});
}