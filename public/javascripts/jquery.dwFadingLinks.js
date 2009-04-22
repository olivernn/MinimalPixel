/*
	Class:    	dwFadingLinks
	Author:   	David Walsh
	Website:    http://davidwalsh.name
	Version:  	1.0.0
	Date:     	10/08/2008
	Built For:  jQuery 1.2.6
*/

jQuery.fn.dwFadingLinks = function(settings) {
	settings = jQuery.extend({
		color: '#ff8c00',
		duration: 500
	}, settings);
	return this.each(function() {
		var original = $(this).css('color');
		$(this).mouseover(function() { $(this).animate({ color: settings.color },settings.duration); });
		$(this).mouseout(function() { $(this).animate({ color: original },settings.duration); });
	});
};

/* sample usage 

$(window).bind('load', function() {
	$('a.fade').fadingLinks('#f00',1000);
});

*/