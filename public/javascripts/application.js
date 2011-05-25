// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function () {
	// This ensures that a path's steps gets deleted from the selected on downwards ...
	$('.deletes').click(function() {
		if ($(this).attr('checked')) {
			$(this).parent().nextAll().find("input[type='checkbox']").attr('checked', $(this).attr('checked'));
		} else {
			$(this).parent().prevAll().find("input[type='checkbox']").attr('checked', $(this).attr('checked'));
		}
	});
});

// hijack jstree links
$('.lba, .lbo, .fwu, .feature').live('click', function() {
	$('.details').load($(this).attr('href'));
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
	$.post($(this).attr('action'), $(this).serialize());
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
    $('#issues').load($(this).attr('href') + ' #issues');
});

$('#new_issue').submit(function(){
  $.ajax({
    type: this.method,
    url: this.action,
    data: $(this).serialize(),
    dataType: "html" //,
    // success: successHandler,
    // error: errorHandler
  });
  return false;
});

/**
* opening modal Dialog for feature description
*/
$('.mapped_feature').live('click', function(e) {
    var $dialog = $('<div class="dialog"></div>')
        .html($(this).next().html())
        .dialog({
          width: 700,
          height: 'auto',
          modal: true,
          title: "Description",
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
    //                title: $(this).text(),
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
    // prevent the default action, e.g., following a link
    return false;
});

