import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    this.perform('comment_channel');
  },

  received(data) {
    console.log(data)

    if (gon.user_id !== data.author_id) {
      $('.question-comments').append(data.body);
    }
  }
});