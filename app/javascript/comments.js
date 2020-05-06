$(document).on('turbolinks:load', function(){
  $(document).on('click', '.new-comment-link', function(event) {
      event.preventDefault();
      $(this).hide();
      var klass = $(this).data('klass');
      var id = $(this).data('id');
      $('form#comment' + '-' + klass + '-' + id).show();
  })
}); 