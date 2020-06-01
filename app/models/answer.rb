class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  validates :body, presence: true
  after_create_commit :notify_subscribers 

  def best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)

      question.set_badge!(author)
    end
  end

  def notify_subscribers
    NewAnswerDigestJob.perform_later(self)
  end
end
