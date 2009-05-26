// adding ajax to the comments form
$(document).ready(function(){
	$("#new_comment").submit(function(){
		$.post(this.action, $(this).serialize(), null, "script");
		return false;
	})
})

// live validation on the sign-up form
// still need some work on the live validation part!
var forms = new Array(".new_user input");
	
$(document).ready(function(){
	$(forms.join(", ")).keyup(function(){
		current_element = $(this);
		var form = $(this).parents().filter('form');
		$(this).delay(800, function(){
			var location = form.attr("action").toString()
			location = location + "/validate"
			$.get(location, form.serialize(), display_validation_errors, "json")
			return false
		})
	})
})

function display_validation_errors(data){
	// remove existing errors
	$("div.fieldWithErrors").unwrap().remove();
	$("span.errorMessage").remove();
	
	// apply errors
	jQuery.each(data.errors, function(index, value){
		var name = value[0];
		var message = value[1];
		var field = $("#" + data.model + "_" + name);
		var label = $("label[for=" + data.model + "_" + name +"]");
		if(!field.parent().hasClass("fieldWithErrors")){
			label.after("<span class='errorMessage'>"+ name + " " + message + " </span>");
			field.wrap("<div class='fieldWithErrors'></div>");
		}
	});
	window.current_element.focus();
}

// hiding and showing the answers to questions
$(document).ready(function(){
	$('.question_link').click(function(){
		$.get($(this).attr("href"), null, null, "script");
		return false;
	})
})