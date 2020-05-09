import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create(
    "AnswerChannel", {
    connected() {
      var questionId = $('.question').data('question-id');
      this.perform('follow', { question_id: questionId });
    },

    received(data) {
      console.log(data)

      if (gon.user_id !== data.author_id) {
        $(`#question-answers-${data.question_id}.answers`).append(data.body);
        window.GistEmbed.init()
      }
    }
  })
});