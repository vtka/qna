$(document).on('turbolinks:load', function(){
  $('.answers').prepend($('.accepted'))

  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    $('.question-edit-form').show();
    $('form#edit-question').removeClass('hidden');
    $('.question .title').hide();
    $('.question .body').hide();
  });
});
