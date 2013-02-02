// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function set_progress(progress) {
  $("#progress-pane-bar").width(progress);
}

function set_message(message) {
  $("#progress-pane-message").text(message);
}

function open_message_pane(job_title) {
  $("#progress-pane-title").text(job_title);
  $("#progress-pane-message").text("");
  set_progress("0%");
  $('#progress-pane').show();
}

function close_message_pane() {
  setTimeout(function() {
    $('#progress-pane').slideUp('slow');                
  }, 1000);
}
