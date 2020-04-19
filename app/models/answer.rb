class Answer < ApplicationRecord

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end
