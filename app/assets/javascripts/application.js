// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require moment
//= require turbolinks
//= require_tree .

$(document).ready(function() {
  $.fn.dataTable.moment( 'HH:mm MMM D, YY' );
  $.fn.dataTable.moment( 'dddd, MMMM Do, YYYY' );
    $('#motion_list').DataTable({
      "order": [[ 0, "desc" ]]
    });
    $('#vote_list').DataTable();
} );

analyze = function(id) {
  console.log("analyze", id);
  $.ajax({
    url: "/api_get_item/"+id,
    cache: true
  }).done(function(res) {
    res = JSON.parse(res);
    console.log(res);
    $("#selected_motion").html(res.motion_ch)
    var t = $('#vote_list').DataTable();
    t.clear().draw();
    res.individual_votes.member.forEach(function(item) {
      t.row.add( [
          item.name_ch,
          item.vote
      ] ).draw( false );
    });
  })
}
