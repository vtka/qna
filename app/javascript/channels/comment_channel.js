import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create("CommentChannel", 
  {
    connected() {
      var answerId = $('.answer').data('answer-id');
      var questionId = $('.question').data('question-id');

      console.log(answerId)
      console.log(questionId)

      this.perform('follow', {
        answer_id: answerId,
        question_id: questionId
      });
    },

    received(data) {
      console.log(data)

      if (gon.user_id !== data.author_id) {
        $(document).find(`#${data.resource_type}-comment-${data.resource_id}`).append(data.body);
      }
    }
  })
});