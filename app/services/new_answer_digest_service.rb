class NewAnswerDigestService
  def send_notification(answer)
    answer.question.subscribers.find_each do |user|
      NewAnswerDigestMailer.send_for(user, answer).deliver_later
    end
    # NewAnswerDigestMailer.send_for(answer).deliver_later
  end
end
