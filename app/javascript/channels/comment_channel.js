import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    this.perform('comment_channel');
  },

  received(data) {
    if (gon.user_id !== data.author_id) {
      $('#' + data.resource_type +
        '-' + data.resource_id + 
        '.' + data.resource_type + 
        '-comments').append(data.body);
      // $('#' + data.resource_type + '-' + data.resource_id).append(data.body);
    }
  }
});