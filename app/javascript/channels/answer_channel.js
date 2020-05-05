import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    this.perform('answer_channel');
  },

  received(data) {
    $('.answers').append(data);
  }
});