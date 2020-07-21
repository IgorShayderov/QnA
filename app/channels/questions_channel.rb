class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'questions'
  end

  def receive(data)
    ActionCable.server.broadcast("chat_#{params[:room]}", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def put_string(string)
    transmit string
  end
end
