// adding ajax to the comments form
$(document).ready(function(){
	$("#new_comment").submit(function(){
		$.post(this.action, $(this).serialize(), null, "script");
		return false;
	})
})