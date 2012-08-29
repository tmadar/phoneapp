function displayCall(call_id) {
	$.ajax({url: "/calls/" + call_id + ".js", dataType: "script"});
}