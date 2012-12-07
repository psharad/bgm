$(function() {
	$( "#sortable" ).sortable({placeholder: "ui-state-highlight"})
	$( "#sortable" ).disableSelection()
	$(".list tr td.img a").fancybox()
	$(".list tr td a.view").fancybox()
})