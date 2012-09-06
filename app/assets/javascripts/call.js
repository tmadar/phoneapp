function displayCall(call_id) {
	$.ajax({url: "/calls/" + call_id + ".js", dataType: "script"});
}

function sortingColumns(){
	$("th").live('click',function(){
		column_name = ( $(this).attr("column-name") != null ? $(this).attr("column-name") : $(this).attr("id") );
		direction = $(this).attr("sorted");
		new_direction = null;
		query = "";
		
		if (direction == "0") {
			new_direction = 1;
		}
		else if (direction == null) {
			new_direction = 0;
		}
		
		if (new_direction != null) {
			query = { sort_by: column_name, direction: new_direction };
		}
		
		$.ajax("/calls", { data: query, dataType: "script" });
	});
	
}