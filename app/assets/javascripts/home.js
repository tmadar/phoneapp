function updateStateOfCall(call_id, new_state) {
	call_url = "/calls/" + call_id + ".json"
	request = $.ajax({
		url: call_url,
		type: 'PUT',
		dataType: 'json',
		data: { call: {disposition: new_state} },
		success: function(data) {
			refreshCalls();
			$("#call_" + call_id + "_disposition").html(new_state + ' <span class="caret"></span>');
		}
	});
}

function modalUpdateStateOfCall(call_id, new_state) {
	call_url = "/calls/" + call_id + ".json"
	request = $.ajax({
		url: call_url,
		type: 'PUT',
		dataType: 'json',
		data: { call: {disposition: new_state} },
		success: function(data) {
			refreshCalls();
			$("#modal_call_" + call_id + "_disposition").html(new_state + ' <span class="caret"></span>');
			$("#call_" + call_id + "_disposition").html(new_state + ' <span class="caret"></span>');
		}
	});
}

function updateAssignmentOfCall(call_id, new_user, full_name) {
	call_url = "/calls/" + call_id + ".json"
	request = $.ajax({
		url: call_url,
		type: 'PUT',
		dataType: 'json',
		data: { call: {user_id: new_user}},
		success: function(data) {
			refreshCalls();
			$("#modal_call_" + call_id + "_assignee").html((data.user.name != null ? data.user.name : data.user.email) + ' <span class="caret" style="float: right;"></span>');
			$("#call_" + call_id + "_assignee").html((data.user.name != null ? data.user.name : data.user.email) + ' <span class="caret" style="float: right;"></span>');
		}
	});
}


function refreshCalls() {
	$.ajax({url: $("[call-ref]").attr("call-ref"), data: { call_div_id: $("[call-ref]").attr("call-update-target"), page: $("[call-ref]").attr("page"), title: $("[call-ref]").parent().find("h1").text() }, dataType: "script"});
}

