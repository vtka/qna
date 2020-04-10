class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
