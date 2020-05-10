import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {
  const question_id = $("#question-channel-provider").data("id");
  
  if (question_id) {
    consumer.subscriptions.create({ channel: "CommentChannel", id: question_id }, {

      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        console.log(data)
  
        if (gon.user_id !== data.author_id) {
          $("body").find(`#question-comment-${data.resource_id}`).append(data.body);
          window.GistEmbed.init()
        }
      }
    });
  }

  const answer_ids = $(".answer-channel-provider").toArray().map(elem => $(elem).data("channel-id"))
  console.log(answer_ids)

  answer_ids.forEach((id) => {
    subscribeToAnswerChannel(id)
  })
})

window.subscribeToAnswerChannel =  function subscribeToAnswerChannel(id) {
  consumer.subscriptions.create({ channel: "CommentChannel", id: id }, {

    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data)

      if (gon.user_id !== data.author_id) {
        $("body").find(`#answer-comment-${data.resource_id}`).append(data.body);
        window.GistEmbed.init()
      }
    }
  });
}