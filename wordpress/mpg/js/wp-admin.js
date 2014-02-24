
jQuery(function () {
	
	jQuery(".wp-editor-area:contains('[')").each(function () {
    jQuery(this).html($(this).html().replace("[", "<span style='color:#ff22ff'>[</span>"));
	});
});