import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    this.perform('comment_channel');
  },

  received(data) {
    if (gon.user_id !== data.author_id) {
      $(`#${data.resource_type}-comment-${data.resource_id}`).append(data.body);
    }
  }
});