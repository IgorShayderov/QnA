import consumer from "./consumer"

consumer.subscriptions.create({
  channel: "CommentsChannel",
  question_id: gon.question_id
}, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received({template, resource_name, resource_id}) {
    // Called when there's incoming data on the websocket for this channels
    $(`.comment-errors-for-${resource_name}-${resource_id}`).after(template);
  }
});
