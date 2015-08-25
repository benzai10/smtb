$(function() {

  $(".select_all_text").on('click', function() {
    this.select();
  });

  $("#disagree-btn").on('click', function() {
    $(".new-entry").removeClass('hidden');
    $(".show-entry").addClass('hidden');
  });

  $("#new-entry-cancel-btn").on('click', function() {
    $(".new-entry").addClass('hidden');
    $(".show-entry").removeClass('hidden');
  });

  $("#edit-entry-cancel-btn").on('click', function() {
    $(".edit-entry").addClass('hidden');
    $(".show-entry").removeClass('hidden');
  });

  $("#edit-entry-btn").on('click', function() {
    $(".show-entry").addClass('hidden');
    $(".edit-entry").removeClass('hidden');
  });
});
