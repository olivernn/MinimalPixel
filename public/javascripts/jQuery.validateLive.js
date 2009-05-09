$.fn.validateLive = function(options){
	
	var defaults = {
		errorMessageClass: 'errorMessage',
		fieldWrapDivClass: 'fieldWithErrors',
		delay: 800
	};
	
	var options = $.extend(defaults, options);
	
	return this.each(function(){
		currentElement = $(this);
		$(this).delay(options.delay, function(){
			$.get($(this.parent('form')).attr("action") + "/validate.js", $(this.parent('form')).serialize(), function(data){
				$("." + defaults.fieldWrapDivClass).unwrap().remove();
				$("." + defaults.errorMessageClass).remove();
				jQuery.each(data.errors, function(index, value){
					var name = value[0];
					var message = value[1];
					var field = $("#" + data.model + "_" + name);
					var label = $("label[for=" + data.model + "_" + name +"]");
					if(!field.parent().hasClass(defaults.errorMessageClass)){
						label.after("<span class='" + defaults.errorMessageClass + "'>"+ name + " " + message + " </span>");
						field.wrap("<div class='" + defaults.fieldWrapDivClass + "'></div>");
					}
					// field.focus();
				});
				window.current_element.focus();
			}, 'json');
		})
	});
}