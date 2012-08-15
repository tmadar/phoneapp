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

function updateAssignmentOfCall(call_id, new_user) {
	call_url = "/calls/" + call_id + ".json"
	request = $.ajax({
		url: call_url,
		type: 'PUT',
		dataType: 'json',
		data: { call: {user_id: new_user}},
		success: function(data) {
			$("#call_" + call_id + "_assignment").html("Updated" + ' <b class="caret"></b>');
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
