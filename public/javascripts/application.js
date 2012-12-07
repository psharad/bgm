var friendsList = [];
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");} });

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
  
  $.get("/posts/load", { 'offset' : 0 }, function(data) {});
  
	$("#pop_member_form").live('submit', function(){
		$("#pop_loader").show()
		$("#member_email").attr('disabled', true)
		$("#member_sex").attr('disabled', true)
		$("#member_age").attr('disabled', true)
	  $.post(this.action, $(this).serialize(), null, "script");
    return false;
	})
})

$(function(){
  $('a[rel*=facebox]').facebox();
  // $('#frm_group').live('submit', function(){
  // 			if (!$('#agree').is(":checked")){
  // 				//alert('Click the checkbox before the Continue button if you have a full understanding of our Terms, Conditions and Disclaimer.')
  // 				return false
  // 			}
  // 			
  // 	})

	$('#next, #add').live('click', function(){
			$('#clicked').val($(this).attr('id'))
			$('#frm_group').submit()
	})
	
  //Enables the submit, update, add buttons if fields are complete
	$('.required').live('change', function(){
			is_clickable = checkForms()
			if (is_clickable){
			  $('#update, #upload_photo_submit, #group_submit, #member_submit, #no_more_member_submit, #preference_submit').attr('disabled', false)
        $('#update, #upload_photo_submit, #group_submit, #member_submit, #no_more_member_submit, #preference_submit').attr('class', 'submit_button')
			}else{
				$('#update, #upload_photo_submit, #group_submit, #member_submit, #preference_submit').attr('disabled', true)
        $('#update, #upload_photo_submit, #group_submit, #member_submit, #preference_submit').attr('class', 'disabled')
			}
	})	
	
  //Enables the button if fields are not empty
	is_clickable = checkForms()
	if (is_clickable){
			$('#add, #update, #upload_photo_submit, #group_submit, #member_submit, #no_more_member_submit, #preference_submit').attr('disabled', false)
	  	$('#add, #update, #upload_photo_submit, #group_submit, #member_submit, #no_more_member_submit, #preference_submit').attr('class', 'submit_button')
	}else{
			$('#add, #update, #upload_photo_submit, #group_submit, #member_submit, #no_more_member_submit, #preference_submit').attr('disabled', true)
	  	$('#add, #update, #upload_photo_submit, #group_submit, #member_submit, #no_more_member_submit, #preference_submit').attr('class', 'disabled')
	}
	
	//   Enables the continue button in Group creation
	// $('.required').live('change', function(){
	// 		is_clickable = checkForms()
	// 		var satisfied = $('#agree').val()
	// 		if (satisfied == 1){
	// 		    if (is_clickable){
	// 					  if ($('#agree').is(":checked")){
	// 					      $('#add').attr('class', 'submit_button')
	// 							  $('#add').attr('disabled', false)
	// 					  }else{
	// 						 		$('#add').attr('class', 'disabled')
	// 					  		$('#add').attr('disabled', true)   
	// 						}
	// 				}else{
	// 						$('#add').attr('disabled', true)
	// 	        	$('#add').attr('class', 'disabled')
	// 				}
	// 				
	// 		}else{
	// 			  if (is_clickable){
	// 				    $('#add').attr('disabled', false)
	//             $('#add').attr('class', 'submit_button')
	//         }else{
	// 	          $('#add').attr('disabled', true)
	// 	          $('#add').attr('class', 'disabled')
	//         }
	// 		}
	// })	
	// 
	// $('#agree').live('click', function(){
	//     	if ($('#agree').is(":checked")){
	//         is_clickable = checkForms()
	//         if (is_clickable){
	//    				  $('#add').attr('class', 'submit_button')
	//     		  $('#add').attr('disabled', false)
	//         }
	// 		}else{
	// 	  		$('#add').attr('class', 'disabled')
	//     		$('#add').attr('disabled', true)   
	//   	}
	//   })
	
	 // Enables the continue button in Group creation
		$('.required').live('change', function(){
				is_clickable = checkForms()
				var satisfied = $('#user_groups_attributes_0_name, #group_name').val()
				if (satisfied == ''){
		        $('#add').attr('disabled', true)
		        $('#add').attr('class', 'disabled')
				}else{
					  if (is_clickable){
						    $('#add').attr('disabled', false)
		            $('#add').attr('class', 'submit_button')
		        }else{
			          $('#add').attr('disabled', true)
			          $('#add').attr('class', 'disabled')
		        }
				}
		})	

		$('#user_groups_attributes_0_name').live('keyup', function(){
			  var group_name = this.val()
		    if (group_name == ''){
					$('#add').attr('class', 'disabled')
	    		$('#add').attr('disabled', true)
				}else{
	        is_clickable = checkForms()
	        if (is_clickable){
	   				  $('#add').attr('class', 'submit_button')
	    		    $('#add').attr('disabled', false)
	        }
		  	}
		 })
		
    $('#group_gender').keydown(function(e){
       if (e.keyCode == 9) {
         var group_name = this.val()
         if (group_name == ''){
            $('#add').attr('class', 'disabled')
            $('#add').attr('disabled', true)
          }else{
                is_clickable = checkForms()
                if (is_clickable){
                    $('#add').attr('class', 'submit_button')
                    $('#add').attr('disabled', false)
                    document.getElementById('add').focus();
                    return false;
                }
          }
         
       }

    });
		// Displays a message if password does not match
    // $(".required").live("keyup", function(){
    //      var password = $("#group_leader_password").val()
    //      var password_confirmation = $("#group_leader_password_confirmation").val()
    //       if (password != password_confirmation){
    //         $(".password_notice").html("Password does not match!")
    //      }else{
    //        $(".password_notice").html("")
    //      }
    // });
    
    // Display message for mismatched password for Group Leader Creation
		$("#group_leader_password").live("keyup", function(){
	    var confirmation = $("#group_leader_password_confirmation").val()
	    var password = this.value
      if (confirmation != password){
        if (confirmation != "" && password != ""){
          $(".instruct").html("Passwords does not match! Please re-enter passwords.")
          $("#group_submit").attr('class', 'disabled')
          $('#group_submit').attr('disabled', true)
        }
	    }else{
	      $(".instruct").html("All fields are required")
        if (is_clickable){
          $("#group_submit").attr('class', 'submit_button')
          $('#group_submit').attr('disabled', false)
        }
	    }
		});
		
		$("#group_leader_password_confirmation").live("keyup", function(){
	    var password = $("#group_leader_password").val()
	    var confirmation = this.value
      if (password != confirmation){
        if (password != "" && confirmation != ""){
          $(".instruct").html("Passwords does not match! Please re-enter passwords.")
          $("#group_submit").attr('class', 'disabled')
          $('#group_submit').attr('disabled', true)
        }
	    }else{
	      $(".instruct").html("All fields are required")
        is_clickable = checkForms()
        if (is_clickable){
          $("#group_submit").attr('class', 'submit_button')
          $('#group_submit').attr('disabled', false)
        }
	    }
		});
		
		// Display message for mismatched password for Account Setting
		$("#user_password").live("keyup", function(){
	    var password_confirmation = $("#user_password_confirmation").val()
      if (password_confirmation != this.value){
        if (password_confirmation == ""){
          $("#update").attr('class', 'disabled')
          $("#update").attr('disabled', true)
        }
        else{
          $(".instruct").html("Passwords does not match! Please re-enter passwords.")
          $("#update").attr('class', 'disabled')
          $("#update").attr('disabled', true)
        }
	    }else{
	      $(".instruct").html("All fields are required")
	      $("#update").attr('class', 'submit_button')
        $("#update").attr('disabled', false)
	    }
		});
		
		$("#user_password_confirmation").live("keyup", function(){
	    var password = $("#user_password").val()
      if (password != this.value){
        if (password == "" ){
          $("#update").attr('class', 'disabled')
          $("#update").attr('disabled', true)
        }else{  
          $(".instruct").html("Passwords does not match! Please re-enter passwords.")
          $("#update").attr('class', 'disabled')
          $("#update").attr('disabled', true)
        }
	    }else{
	      $(".instruct").html("All fields are required")
	      $("#update").attr('class', 'submit_button')
        $("#update").attr('disabled', false)
	    }
		});
   
	// For Preference Description
	// $('#preference_description').live('keyup', function(){
	// 	  is_Empty = prefDesc()
	// 	  if(is_Empty){
	// 		    is_clickable = checkForms()
	// 		    if (is_clickable){
	// 		        $('#preference_submit').attr('disabled', false)
	// 		        $('#preference_submit').attr('class', 'submit_button')
	// 	      }else{
	// 	          $('#preference_submit').attr('disabled', true)
	// 	          $('#preference_submit').attr('class', 'disabled')			  
	// 	      }
	// 	  }else{
	// 		    $('#preference_submit').attr('disabled', true)
	// 		    $('#preference_submit').attr('class', 'disabled')
	// 	  }
	// })
	
	//Enable the email_submit button if email field is not empty 
	$('#email').live('keyup', function(){
		is_Empty = emailForgot()
		if (is_Empty){
			$('#email_submit').attr('disabled', false)
			$('#email_submit').attr('class', 'submit_button')
		}else{
			$('#email_submit').attr('disabled', true)
			$('#email_submit').attr('class', 'disabled')
		}
	})
	
	$('.login').live('keyup', function(){
		is_Empty = emailPass()
		if (is_Empty){
			$('#user_session_submit').attr('disabled', false)
			$('#user_session_submit').attr('class', 'submit_button')
		}else{
			$('#user_session_submit').attr('disabled', true)
			$('#user_session_submit').attr('class', 'disabled')
		}
	})
	
  $(window).load(function(){
		is_Empty = emailPass();
	  if (is_Empty){
			$('#user_session_submit').attr('disabled', false)
			$('#user_session_submit').attr('class', 'submit_button')
		}else{
			$('#user_session_submit').attr('disabled', true)
			$('#user_session_submit').attr('class', 'disabled')		
		}
	});


  $('.admin_login').live('keyup', function(){
	  is_Empty = adminPass();
	  if (is_Empty){
		  $('#admin_session_submit').attr('disabled', false)
		  $('#admin_session_submit').attr('class', 'submit_button')
	  }else{
		  $('#admin_session_submit').attr('disabled', true)
		  $('#admin_session_submit').attr('class', 'disabled')
	  }
  });
	$('#user_groups_attributes_0_name').live('keyup', function() {
    $.get('/groups/check_group?group='+$(this).val(), $(this).serialize(), null, "script");
  })
	
	//Hides img element if image is missing
	if ($('img').attr('alt') == 'Missing'){
		$('img').hide()
	}
		
}) //end function

function closeFacebox(){
  jQuery(document).trigger('close.facebox')
}

function emailPass(){
	// Login 
	var user_session_email = $('#user_session_email').val()
	var user_session_password = $('#user_session_password').val()
	
	if (user_session_email == '' || user_session_password == ''){
		return false
	} else{
		return true
	}
}

function emailForgot(){
	// Forgot Password
	var email = $('#email').val()
	
	if (email == ''){ 
		return false
	} else{
	  return true
	}
}

function adminPass(){
  var username = $('#admin_session_username').val();
  var password = $('#admin_session_password').val();	

  if (username == '' || password == ''){
	  return false
  }else{
	  return true 
  }
}

function prefDesc(){
	// Preference Description
	var preference_description = $('#preference_description').val()
	
	if (preference_description == ''){ 
		return false
	} else{
	  return true
	}
}

$(function() {
	var cache = {},
	lastXhr;
	var mpos = $('input#mpos').val();
	$( ".email_check" ).autocomplete({
		minLength: 2,
		select: function (event,ui) {
      $.get('/members/search_by_email?email='+ui.item.value+'&mpos='+mpos, $(this).serialize(), null, "script");
    },
		source: function( request, response ) {
			var term = request.term;
			
			if ( term in cache ) {
				response( cache[ term ] );
				return;
			}

			lastXhr = $.getJSON( "/members/email_value?mpos="+mpos, request, function( data, status, xhr ) {
				cache[ term ] = data;
				if ( xhr === lastXhr ) {
					response( data );
				}
			});
		}
	});
});

$(function() {
	var cache = {},
	lastXhr;
	$( ".edit_email_check" ).autocomplete({
		minLength: 2,
		select: function (event,ui) {
      $.get('/members/edit_search_by_email?email='+ui.item.value, $(this).serialize(), null, "script");
    },
		source: function( request, response ) {
			var term = request.term;
			if ( term in cache ) {
				response( cache[ term ] );
				return;
			}

			lastXhr = $.getJSON( "/members/email_value", request, function( data, status, xhr ) {
				cache[ term ] = data;
				if ( xhr === lastXhr ) {
					response( data );
				}
			});
		}
	});
});

function checkForms(){
	
	// For Groups
	var group_name = $('#group_name').val()
	var group_city_id = $('#group_city_id').val()
	var group_zip = $('#group_zip').val()
	var group_size = $('#group_size').val()
	var group_gender = $('#group_gender').val()	

	var user_group_attributes_name = $('#user_groups_attributes_0_name').val()
	var user_group_attributes_city_id = $('#user_groups_attributes_0_city_id').val()
	var user_group_attributes_zip = $('#user_groups_attributes_0_zip').val()
	var user_group_attributes_size = $('#user_groups_attributes_0_size').val()
	var user_group_attributes_gender = $('#user_groups_attributes_0_gender').val()
	
	// For User
	var user_email = $('#group_leader_email').val()
	var user_password = $('#group_leader_password').val()
	var user_password_confirmation = $('#group_leader_password_confirmation').val()
	var user_edit_password = $('#user_password').val()
	var user_edit_password_confirmation = $('#user_password_confirmation').val()
	var user_sex = $('#group_leader_sex').val()
	var user_age = $('#group_leader_age').val()

	    var user_height = ''
	    var user_build = ''
	    var user_ethnicity = ''
	    var user_education = ''


	    try {
      		user_height = $('#group_leader_height_id').val()
      		user_build = $('#group_leader_built_id').val()
      		user_ethnicity = $('#group_leader_ethnicity_id').val()
      		user_education = $('#group_leader_education_id').val()
	    } catch(err) {
      		user_height = ' '
      		user_build = ' '
	        user_ethnicity = ' '
	        user_education = ' '
	    }


  //For Members
  var member_email = $('#member_email').val()
  var member_sex = $('#member_sex').val()
	var member_age = $('#member_age').val()

  var preference_interest = $('#preference_interest_id').val()
  var preference_day = $('#preference_day_id').val()
  var preference_availability = $('#preference_availability_id').val()
  //var preference_description = $('#preference_description').val()

  var group_photo = $('#g_image_photo').val()

	    var member_height = ''
	    var member_build = ''
	    var member_ethnicity = ''
	    var member_education = ''


	    try {
      		member_height = $('#member_height_id').val()
      		member_build = $('#member_built_id').val()
      		member_ethnicity = $('#member_ethnicity_id').val()
	        member_education = $('#member_education_id').val()
	    } catch(err) {
	        member_height = ' '
	      	member_build = ' '
	        member_ethnicity = ' '
	        member_education = ' '
	    }
  
  //if (user_group_attributes_name == '' || user_group_attributes_city_id == '' || user_group_attributes_zip == '' || user_group_attributes_size == '' || user_group_attributes_gender == '' || group_name == '' || group_city_id == '' || group_zip == '' || group_size == '' || group_gender == '' || user_email == '' || user_password == '' || user_password_confirmation == '' || user_password != user_password_confirmation || user_edit_password != user_edit_password_confirmation || user_sex == '' || user_age == '' || member_email == '' || member_sex == '' || member_age == '' || preference_interest == '' || preference_day == '' || preference_availability == '' || group_photo == '' || user_height == '' || user_build == '' || user_ethnicity == '' || user_education == '' || member_height == '' || member_build == '' || member_ethnicity == '' || member_education == '') {
	if (user_group_attributes_name == '' || user_group_attributes_city_id == '' || user_group_attributes_zip == '' || user_group_attributes_size == '' || user_group_attributes_gender == '' || group_name == '' || group_city_id == '' || group_zip == '' || group_size == '' || group_gender == '' || user_email == '' || user_password == '' || user_password_confirmation == '' || user_password != user_password_confirmation || user_edit_password != user_edit_password_confirmation || user_sex == '' || user_age == '' || member_email == '' || member_sex == '' || member_age == '' || preference_interest == '' || preference_day == '' || preference_availability == '' || group_photo == '') {
		return false
	}	else{
		return true
	}
}

function facebookpopup(url) {
  newwindow=window.open(url,'name','height=670,width=615');
  if (window.focus) {newwindow.focus();}
  return false;
}

function popitup(url) {
	window.location = url
  // newwindow=window.open(url,'name','height=670,width=615');
  // if (window.focus) {newwindow.focus();}
  // return false;
}

// Limit Autocomplete results
$(function() {
	$.ui.autocomplete.prototype._renderMenu = function( ul, items ) {
	var self = this;
	$.each( items, function( index, item ) {
	   if (index < 10) // here we define how many results to show
	      {self._renderItem( ul, item );}
	   });
	}
});

//form submission
$(function(){
	$('#new_user').live('submit', function(){
			if ($('#add').is(':disabled')){ return false}
	})

	$('.edit_user').live('submit', function(){
			if ($('#update').is(':disabled')){ return false}
	})

	$('.edit_member, #new_member').live('submit', function(){
			if ($('#member_submit').is(':disabled')){ return false}
	})

	$('#new_preference').live('submit', function(){
			if ($('#preference_submit').is(':disabled')){ return false}
	})
	
})

$(function() {
	$( "#tabs" ).tabs({
	})
})

function blog_2() {
  $.get("/posts/load", { 'offset' : 4 }, function(data) {});
  $('#menu_2').show();
  $('#menu_1').hide();
}

function blog_1() {
  $.get("/posts/load", { 'offset' : 0 }, function(data) {});
  $('#menu_1').show();
  $('#menu_2').hide();  
}

// Blog Posts Toggle
$(function() {
	$(".page_2").live('click', function(){
      $.get("/posts/load", { 'offset' : 4 }, function(data) {
      });
      $('#menu_2').show();
      $('#menu_1').hide();
	});
	
	$(".page_1").live('click', function(){
      $.get("/posts/load", { 'offset' : 0 }, function(data) {
      });
      $('#menu_1').show();
      $('#menu_2').hide();
	});


  $("#forum").toggle(function()
  { // first click hides login form, shows password recovery
    blog_2();
  },
  function()
  { // next click shows login form, hides password recovery
    blog_1();
  });
});

$(function() {
  // Local Offers Toggle
  $(".local_offers").live('click', function(){
      $.get("/local_offers/load", { 'offset' : 4 }, function(data) {
      });
  });


});

function local_offer_sent_alert(){
  $.fancybox(
		'<p style="text-align:center;color:#000;">Local offer has been sent.</p>',
    {
      'autoDimensions'	: false,
      'width'         		: 150,
      'height'        		: 'auto',
      'transitionIn'		: 'none',
      'transitionOut'		: 'none'
    }
  );
}

//Local Offers - Send Email
$("#send_local_offer").live("click", function() {
  //console.log($('#local_offer_email_recipient').val());
  if (!$('#local_offer_email_recipient').val()) {
    alert('Please enter email address.');
    return false;
  }

  if (!validateEmail($('#local_offer_email_recipient').val())) {
    alert('Please enter valid email address.');
    return false;
  }
  
  $.get("/local_offers/send_local_offer", { 'email' : $('#local_offer_email_recipient').val(), 'local_offer_id' : $('#local_offer_id').val() }, function(data) { 
    //alert('Local Offer Sent.');
    local_offer_sent_alert();
    $.fancybox.close();
  });
});


$(".send_local_offer_logged_in").live("click", function() {
  $.get("/local_offers/send_local_offer", { 'email' : $(this).attr('email'), 'local_offer_id' : $(this).attr('id') }, function(data) {
    local_offer_sent_alert();
  });
  return false;
});

function validateEmail(email) 
{ 
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/ 
    return email.match(re) 
}

//More Tweets
$('.more_tweets').live("click", function() {
  $.get("/homes/more_tweets", { 'page' : $(this).attr('page')}, function(data) {
  });
  return false; 
});

$('.read_more_post').live("click", function() {
  var post_url = $(this).attr('href');
  
  //find /posts/
  if ($('.bloggers').length > 0) {
    var redirect_to_home = function() {};
  }
  else {
    var redirect_to_home = function() {
      window.location = '/';
    }
  }
  $.get(post_url, function(data) {
    $.fancybox(
      {
        'transitionIn'	:	'elastic',
        'transitionOut'	:	'elastic',
        'speedIn'		:	600, 
        'speedOut'		:	200, 
        'overlayShow'	:	true,
        'href' : post_url + '/main',
        'onClosed' : redirect_to_home
      }
    );
  });
  return false; 
});
