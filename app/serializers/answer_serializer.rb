class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :author_id

  has_many :links
  has_many :comments
  has_many :files
  belongs_to :author, class_name: 'User'
  belongs_to :question
end