class AnswerChannel < ApplicationCable::Channel
  def subscribed
    question = GlobalID::Locator.locate(params[:id])
    stream_for question
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
