// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function () {
	// This ensures that a path's steps gets deleted from the selected on downwards ...
	$('.deletes').click(function() {
	  $this = $(this);
		if ($this.attr('checked')) {
			$this.closest('.step').nextAll().find("input[type='checkbox']").attr('checked', $this.attr('checked'));
		} else {
			$this.closest('.step').prevAll().find("input[type='checkbox']").attr('checked', $this.attr('checked'));
		}
	});
});

// hijack jstree links
$('.lba, .lbo, .fwu, .feature, .build_feature').live('click', function() {
	$('.tree-details').load($(this).attr('href'));
	return false;
});

// makes sure the csrf token gets send with every AJAX call as per
// http://weblog.rubyonrails.org/2011/2/8/csrf-protection-bypass-in-ruby-on-rails
$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});

// hijack ajax buttons
$('.ajax').live('submit', function(e) {
  e.preventDefault();
  $.ajax({
    type: "POST",
    url: $(this).attr('action'),
    data: $(this).serialize(),
    dataType: 'json',
    context: $(this),
    cache: false,
    success: function(returnData){
      $('div.dialog').remove();
      $("#refresh_issues").trigger("click");
    }
  });
});


// hijack watching links
$('.watching').live({
  mouseover: function(e) {
               $(this).addClass("over");
  },
  mouseout: function(e) {
               $(this).removeClass("over");
  }
});

$('.watching.add').live('click', function(e) {
	e.preventDefault();
  $(this).attr('class', 'watching loading')
	$.ajax({
	  type: "POST",
	  url: $(this).attr('href'),
	  dataType: "json",
	  context: $(this),
	  success: function(data){
	    $(this)
	      .attr('href', $(this).attr('href') + "/" + data.watching.id)
	      .attr('class', 'watching remove')
	      .attr('title','Click to remove from watchlist');
    }
  });


//	$.post($(this).attr('href'),
//	  context: $(this),
//    function() {
//  	  alert('whohoo');
//  });
});

$('.watching.remove').live('click', function(e) {
	e.preventDefault();
  $(this).attr('class', 'watching loading')
  $.ajax({
	  type: "DELETE",
	  url: $(this).attr('href'),
	  dataType: "json",
	  context: $(this),
	  success: function(data){
	    var pattern=/\/business_processes\/[0-9]+\/watchings/
	    $(this)
	      .attr('href', pattern.exec($(this).attr('href')))
	      .attr('class', 'watching add')
	      .attr('title','Click to add to watchlist');
    }
  });
});

// hijack update_owner buttons
$('.update_owner').live('click', function(e) {
	e.preventDefault();
	$.ajax({
		url: $(this).attr('href'),
		success: function(owner){
		  $('#owner').html(owner.user.username);
		}
	});
});


function removeHTMLTags(htmlString) {
    if(htmlString)
    {
      var mydiv = document.createElement("div");
       mydiv.innerHTML = htmlString;

        if (document.all) // IE Stuff
        {
            return mydiv.innerText;
        }
        else // Mozilla does not work with innerText
        {
            return mydiv.textContent.replace(/\>+(?= )/g,'');
        }
    }
};


// hijack show-hide buttons
$('#toggle_description, #toggle_issues').live('click', function(e) {
	e.preventDefault();
	$('#'+ this.id.toString().replace("toggle_", "")).slideToggle(200);;
//	$('.description').slideToggle(200);
	$(this).text($(this).text() == 'Show' ? 'Hide' : 'Show');
});


/**
* opening modal Dialog
*/
$('.dialog_form_link').live('click', function() {
    var $dialog = $('<div class="dialog"></div>')
        .appendTo('body')
        .load($(this).attr('href') + ' form', function(response, status, xhr){
            if (status == "error") {
                var msg = "Sorry but there was an error: ";
                addNotice("<p>" + msg + xhr.status + " " + xhr.statusText + "</p>")
            } else {
                $(this).dialog({
                    modal: true,
    //                title: $(this).text(),
    //                autoOpen: false,
                    width: 'auto',
                    height: 'auto',
                    position: 'center',
                    show: {effect: 'blind',
                           duration: 250
                    },
                    hide: {effect: 'blind', duration: 250},
                    close: function(ev, ui) { $('div.dialog').remove(); }
                });
            }
        });
//    $dialog.dialog('open');
    // prevent the default action, e.g., following a link
    return false;
});

// hijack refresh button
$('#refresh_issues').live('click', function(e) {
    e.preventDefault();
    $('#issues').load($(this).attr('href'));
});

//$('#new_issue').submit(function(){
//  $.ajax({
//    type: this.method,
//    url: this.action,
//    data: $(this).serialize(),
//    dataType: "html" //,
//    // success: successHandler,
//    // error: errorHandler
//  });
//  return false;
//});

/**
* opening modal Dialog for feature description
*/
$('.mapped_feature').live('click', function(e) {
       var $dialog = $('<div class="dialog"></div>')
           .html($(this).next().html())
           .dialog({
             width: 700,
             height: 700,
             modal: true,
             title: "Details",
             show: {effect: 'blind',
                    duration: 250
             },
             hide: {effect: 'blind', duration: 250},
             close: function(ev, ui) { $('div.dialog').remove(); }
           });

    return false;
});




/**
* opening modal Dialog
*/
$('.dialog_link').live('click', function() {
    var $dialog = $('<div class="dialog"></div>')
        .load($(this).attr('href') + ' span#description', function(response, status, xhr){
            if (status == "error") {
                var msg = "Sorry but there was an error: ";
                addNotice("<p>" + msg + xhr.status + " " + xhr.statusText + "</p>")
            } else {
                $(this).dialog({
                    modal: true,
                    title: "Details",
                    width: 700,
                    height: 700,
                    position: 'center',
                    show: {effect: 'blind',
                           duration: 250
                    },
                    hide: {effect: 'blind', duration: 250},
                    close: function(ev, ui) { $('div.dialog').remove(); }
                });
            }
        });
    // prevent the default action, e.g., following a link
    return false;
});

/**
* JSTree Supporting code
*/
$(function () {
	$("#add_lba, #add_lbo, #add_fwu, #add_feature").click(function () {
	  $("#lba_tree").jstree("create", null, "last", { "attr" : { "rel" : this.id.toString().replace("add_", "") } });
  });
	$("#remove, #rename").click(function () {
    $("#lba_tree").jstree(this.id);
  });
	$("#open_all").click(function () {
	  $("#lba_tree").jstree("open_all");
  });
	$("#close_all").click(function () {
	  $("#lba_tree").jstree("close_all");
  });
	$("#open_current").click(function (e,data) {
	  $("#lba_tree").jstree("open_all", ".jstree-clicked");
  });
	$("#close_current").click(function (e,data) {
	  $("#lba_tree").jstree("close_all", ".jstree-clicked");
  });
});

/**
* Support for Sortable Lists
*/
$(document).ready(function() {
	$( "#sortable" ).sortable( {
  	opacity: 0.6,
  	scroll: true,
    update: function() {
      $.ajax({
        type: 'post',
        data: $("#sortable").sortable('serialize'),
        success: function(r){
          $('.priority-number').each(function(i) {
            $(this).text(i+1);
          });
        },
        url: '/manage_priorities/prioritize_paths'
      })
    }
  });
	$( "#sortable" ).disableSelection();
});

$(function() {
	$("#iterations").change(function() {
	var iteration = $('select#iterations :selected').val();
	$.get('/reports/iteration_change_listener/' + iteration, function(data){
	$("#select_project").html(data);})
	return false;}
	);
    });

$('#projects').live('change', function() {
	var project = $('select#projects :selected').val();
	$.get('/reports/project_change_listener/' + project, function(data){$("#select_usecase").html(data);});
	return false;
});


$(function() {
	$('#selectForm').submit(function(){
	var param = $(this).serialize();
	$.get('/reports/updateChart/' + param, function(data){$("#burn_chart").html(data);});
	return false;
	});});

//  Path tags facebook style
 $(document).ready(function() {
  $("#path_fbstyle_tag_tokens").tokenInput("/lookups/tagsvvo.json", {
    crossDomain: false,
    prePopulate: $(this).data("pre"),
    preventDuplicates: true,
    theme: "facebook"
  });
});


//  Path developers facebook style
 $(document).ready(function() {
  $("#path_fbstyle_devloper_tokens").tokenInput("/lookups/developersVVo.json", {
    crossDomain: false,
    prePopulate: $(this).data("pre"),
    preventDuplicates: true,
    theme: "facebook"
  });
});

// hijack More links
$(document).ready(function () {
  $(".show_more").click(function(e) {
    // alert('it works');
    $(e.target).parent().parent().next().toggle();
    return false;
  });
  $(".show_all").click(function(e) {
    $('.more').toggle();
    return false;
  });
});

