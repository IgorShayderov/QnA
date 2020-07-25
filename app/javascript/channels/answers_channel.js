import consumer from "./consumer"
import createAnswer from '../utilities/create_answer';

consumer.subscriptions.create(
  {
    channel: "AnswersChannel",
    question_id: gon.question_id
  }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received({answer, is_author, links}) {
      // Called when there's incoming data on the websocket for this channel
      createAnswer(answer, is_author, links);
    }
  }
);
