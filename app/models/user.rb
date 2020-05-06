class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :questions, foreign_key: 'author_id'
  has_many :answers, foreign_key: 'author_id'
  has_many :badges, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :delete_all

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(object)
    self.id == object.author_id
  end

  def voted?(resource)
    votes.exists?(votable: resource)
  end

end
