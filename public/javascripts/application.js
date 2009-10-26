// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// making sure that each ajax request sets the content type to javascript
jQuery.ajaxSetup({
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.unwrap = function () {
   return this.each( function(){
      $(this.childNodes).insertBefore(this);
   });
};

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

//this is the ajax functionality on the item pictures in the carosel
$(document).ready(function(){
	$('.carousel').click(function(){
		$("#item_view").hide().html('<img src="/images/ajax-loader.gif" alt="Wait" class="spinner" />').fadeIn(1250);
		$.get($(this).attr("href") + ".js", null, null, "script");
		return false;
	})
})

// using modal box to display the large images
$(document).ready(function(){
	$('a.lightbox').click(function(e){
		e.preventDefault();
		$.modal("<img src='" + $(this).attr("href") + "'/>",{
			opacity: 75,
			containerCss:{backgroundColor: '#fff'},
			position:[50,50],
			onOpen: function(dialog){
				dialog.overlay.fadeIn('slow', function(){
					dialog.container.slideDown('slow', function(){
						dialog.data.fadeIn('slow');
					});
				});
			},
			onClose: function(dialog){
				dialog.data.fadeOut('slow', function(){
					dialog.container.slideUp('slow', function(){
						dialog.overlay.fadeOut('slow', function(){
							$.modal.close();
						})
					})
				})
			}
		});
	})
})

var forms = new Array(
		 // ** removed this because not sure there is any benefit in live validation for the draft projects
		 // ** also it was causing a problem with many errors.
	   // ".new_project input",
	   // ".new_project textarea",
	   ".new_page input",
	   ".new_page textarea",
	   ".new_user input",
	   ".new_contact_form input",
	   ".new_contact_form textarea");

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

// adding an instant update of the style attributes when editing the styles
$(document).ready(function(){
	$(".edit_style input, .edit_style select").change(function(){
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

//creating the menu
$(document).ready(function(){
	$('#main_menu').superfish({
		delay:800,
		animation: {opacity:'show',height:'show'},
		speed: 'slow'
	});
})

//making the items on the items index page sortable
//also adds the callback to persist the order in the db
$().ready(function() {
      $('#items').tableDnD({
        onDrop: function(table, row) {
          $.ajax({
             type: "PUT",
             url: window.location + "/sort",
             processData: false,
             data: $.tableDnD.serialize(),
             success: function(msg) {
               alert("Items succesfully sorted")
             }
           });
        }
      })
    })

// getting a change of colour to trigger a change
$(document).ready(function(){
	$('#iColorPicker').click(function(){
		$('.iColorPicker').change();
	});
})

// getting started notes
$(document).ready(function(){
	var getStartedContent = $('.get_started');
	if (getStartedContent.length){
		getStartedContent.modal({
			opacity:75,
			containerCss:{height:200, width:500},
			onClose: function(dialog){
				dialog.data.fadeOut('slow', function(){
					dialog.container.slideUp('slow', function(){
						dialog.overlay.fadeOut('slow', function(){
							$.modal.close();
						})
					})
				})
			}
		});
	}
});

$(document).ready(function () {
	$('#basicModal input.basic, #basicModal a.basic').click(function (e) {
		e.preventDefault();
		$('#basicModalContent').modal();
	});
});