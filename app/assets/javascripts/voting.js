$(document).on('turbolinks:load', function(){
  $('.voting').on('ajax:success', function(e){
      var xhr = e.detail[0];
      var resource = xhr['resource'];
      var id = xhr['id'];
      var votetype = xhr['votetype']
      var votecount = xhr['votecount'];

      $('#' + resource + '-' + id + ' .voting .votecount').html(votecount);

      var upvoteButton = $('#' + resource + '-' + id + ' .voting .upvote-button');
      var downvoteButton = $('#' + resource + '-' + id + ' .voting .downvote-button');

      upvoteButton.removeClass("upvoted");
      upvoteButton.removeClass("no-vote");
      downvoteButton.removeClass("downvoted");
      downvoteButton.removeClass("no-vote");

      if(votetype == 'upvote'){
        upvoteButton.addClass("upvoted");
        downvoteButton.addClass("no-vote");
      }
      else if (votetype == 'downvote'){
        downvoteButton.addClass("downvoted");
        upvoteButton.addClass("no-vote");
      }
  });
});
