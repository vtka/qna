import consumer from "./consumer"

$(document).on("turbolinks:load", function(e) {
  const question_id = $("#question-channel-provider").data("id");
  
  if (question_id) {
    consumer.subscriptions.create({ channel: "AnswerChannel", id: question_id }, {

      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        console.log(data)
  
        if (gon.user_id !== data.author_id) {
          $("body").find(".answers").append(data.body);
          window.GistEmbed.init()
        }
      }
    });
  }
})