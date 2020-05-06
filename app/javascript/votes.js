$(document).on('turbolinks:load', function(){
  $('body').on('ajax:success', '.rate .voting', function(event){
    var response = event.detail[0];
    var voteId = '.' + response.klass + '-' + response.id

    $(voteId + ' .rating').html('<p>' + 'Rating: ' + response.score + '</p>');
    $(voteId + ' .voting').addClass('hidden');
    $(voteId + ' .revote-link').removeClass('hidden');
    $('.flash').html(response.flash)
   })

  $('body').on('ajax:success', '.revote', function(event){
    var response = event.detail[0];
    var voteId = '.' + response.klass + '-' + response.id

    $(voteId + ' .rating').html('<p>' + 'Rating: ' + response.score + '</p>');
    $(voteId + ' .revote-link').addClass('hidden');
    $(voteId + ' .voting').removeClass('hidden');
    $('.flash').html('')
   })
}); 