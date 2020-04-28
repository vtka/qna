$(document).on('turbolinks:load', function(){
  $('.rate .voting').on('ajax:success', function(event){
    var response = event.detail[0];
    var voteId = '.' + response.klass + '-' + response.id

    $(voteId + ' .rating').html('<p>' + 'Rating: ' + response.score + '</p>');
    $(voteId + ' .voting').addClass('hidden');
    $(voteId + ' .revote-link').removeClass('hidden');
    $('.flash').html(response.flash)
   })

  $('.revote').on('ajax:success', function(event){
    var response = event.detail[0];
    var voteId = '.' + response.klass + '-' + response.id

    $(voteId + ' .rating').html('<p>' + 'Rating: ' + response.score + '</p>');
    $(voteId + ' .revote-link').addClass('hidden');
    $(voteId + ' .voting').removeClass('hidden');
    $('.flash').html('')
   })
}); 