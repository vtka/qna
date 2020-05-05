class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def accept!
    ActiveRecord::Base.transaction do
      question.answers.update_all(accepted: false)
      update!(accepted: true)
      question.give_award_to(author)
    end
  end
end
