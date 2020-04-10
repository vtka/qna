$(document).on('turbolinks:load', function(){

  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.edit-question-form').show();
    $('form#edit-question').removeClass('hidden');
    $('.question .title').hide();
    $('.question .body').hide();
    $('.question .back-link').hide();
  });
});