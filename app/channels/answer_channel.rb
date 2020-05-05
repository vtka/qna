class AnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'answer_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
