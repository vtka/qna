import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    this.perform('answer_channel');
  },

  received(data) {
    console.log(data)

    if (gon.user_id !== data.author_id) {
      $('.answers').append(data.body);
    }
  }
});