//MPG custom scripts

//initiate tooltips
jQuery(function () {
	jQuery('[data-toggle="tooltip"]').tooltip();
});

//jQuery(function () {
//	jQuery(".gallery a").attr("rel","lightbox[12]");
//});

 //Homepage show/hide mid roll-overs
jQuery(document).ready(function() {
    jQuery('.home-mid-light ul li').hover(function() {
			//get li position for arrow
			var pos = jQuery(this).position();
			var wid = jQuery(this).outerWidth();
			
			var poswid = pos.left + wid/2 - 25;
				//hide div
				jQuery(this).siblings().find('div:first').stop().fadeTo(400,0, function() {$(this).hide()});
				//shw current
        jQuery(this).find('div:first').stop().show().fadeTo(400,1);
				//move arrow
        jQuery(this).find('div span:first').stop().animate ({ 'background-position-x': + poswid + 'px'});
        jQuery(this).siblings().find('div span:first').stop().animate ({ 'background-position-x': + poswid + 'px'});
				//bring current div to fore
        jQuery(this).siblings().find('div:first').css ({ 'z-index': '4999'});
        jQuery(this).find('div:first').css ({ 'z-index': '5000'});
    }, function() {
				//remember last rollover using zindex... (sort of!)
        jQuery(this).siblings().find('div:first').css ({ 'z-index': '4999'});
    });
		
});

// remove margin from last gallery item
jQuery(function () {
	jQuery(".gallery-item").last().css({marginRight:"0px"})
});

//Sort out ajax v align on forms
jQuery(function () {
	//jQuery(this).find('.gform_anchor:first').css ({ 'display': 'inline'});
	jQuery('.gform_anchor').remove();
	//jQuery(this).find('.gform_page_footer:first').css ({ 'display': 'none'});
	
	if (jQuery('.gform_page').length) {
		jQuery('body').addClass('gf-form')
	} else {
		jQuery('body').removeClass('gf-form')
	};
	
});

// remoave title everywhere!
jQuery('document').ready(function($){
	jQuery('.gallery-icon a').find('[title]').removeAttr('title');
});

// Set divs the same height twitter_bs row
jQuery(document).ready(function(){
	jQuery('.row').each(function(){  
			 var $columns = jQuery('.awards-ad-container',this);
			 var maxHeight = Math.max.apply(Math, $columns.map(function(){
					 return jQuery(this).height();
			 }).get());
			 $columns.height(maxHeight);
	});
});

//Allow modal to pull in external sources - Gravity forms
jQuery(document).ready(function () {
	jQuery('#formModal').on('hidden', function () {
	  jQuery(this).removeData('modal');
	});
});


//Gravity forms - select only one poll
/*
jQuery(document).ready(function () {
    $('input[type=radio]').change(function()
				{
						if (this.checked)
						{  
								$(this).closest('.gpoll_field')
								.find('input[type=radio]').not(this)
								.prop('checked', false);
						}
				});
});
*/