$(document).on('turbolinks:load', function(){
  if (document.querySelector('.answers')) {
    App.answersSubscription = App.cable.subscriptions.create('AnswersChannel', {
      connected: function() {
        questionId = $('.question').attr('id').split("-")[1];
        this.perform('follow', {
          question_id: questionId
        });
      },

      received: function(data) {
        if (gon.current_user !== data.answer.author_id) {
          $('.answers').append(JST['templates/answer']({
            answer: data.answer,
            files: data.files,
            links: data.links
          }));
        }
      }
    });
  } else {
    if (App.answersSubscription) {
      App.answersSubscription.unsubscribe();
    }
  }
});