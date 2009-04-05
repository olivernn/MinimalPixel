// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// making sure that each ajax request sets the content type to javascript
jQuery.ajaxSetup({
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

// adding support for the PUT and DELETE http requests
function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}


jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});


// adding an instant update of the style attributes when editing the styles
$(document).ready(function(){
	$(".edit_style input").change(function(){
		$.put($(".edit_style").attr("action"), $(this).serialize(), null, "script");
		return false;
	})
})

// giveing a preview of the available fonts
$(document).ready(function(){
	$(".font_label").each(function(){
		$(this).sifr({
			font: $(this).attr("id")
		})
	})
})