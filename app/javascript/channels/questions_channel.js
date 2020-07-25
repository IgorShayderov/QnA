import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  initialized() {

  },
  connected() {
    // Called when the subscription is ready for use on the server
    // this.perform('recieve', { text: 'string string moon sun' });
  }, 

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    $('.all-questions').append(data);
  }
});
