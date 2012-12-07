$(function(){
	$("a#image, a#box").fancybox({
		'transitionIn'	:	'elastic',
		'transitionOut'	:	'elastic',
		'speedIn'		:	600, 
		'speedOut'		:	200, 
		'overlayShow'	:	true		
	});
	
	$("a[rel=main_group]").fancybox({
     'transitionIn'      : 'none',
     'transitionOut'     : 'none',
     'titlePosition'     : 'over',		
     'titleFormat'       : function(title, currentArray, currentIndex, currentOpts) {
         return '<span id="fancybox-title-over">' +  (currentIndex + 1) + ' / ' + currentArray.length + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + title + '</span>';
      }
	});
	
	$("a#sub-box").live('hover', function(){
	  $(this).fancybox();
	})

	$(".instruct a").fancybox();



});

