import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    this.perform('answer_channel');
  },

  received(data) {
    console.log(data)

    if (gon.user_id !== data.author_id) {
      $('#question-answers-' + data.question_id + '.answers').append(data.body);
    }
  }
});