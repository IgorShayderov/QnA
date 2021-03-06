# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "questions/#{params[:question_id]}/answers"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
