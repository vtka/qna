class CommentChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['question_id']}-comments"
    stream_from "answer-#{data['answer_id']}-comments"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
