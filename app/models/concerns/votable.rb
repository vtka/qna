module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(user)
    vote(user, 1)
  end

  def downvote(user)
    vote(user, -1)
  end

  def votecount
    votes.sum(:direction) + 1
  end

  def upvoted?(user)
    duplicate_vote?(user, 1)
  end

  def downvoted?(user)
    duplicate_vote?(user, -1)
  end

  private

  def vote(user, direction)
    return false if user.author_of?(self) || duplicate_vote?(user, direction)

    transaction do
      last_vote(user)&.destroy!
      votes.create!(user: user, direction: direction)
    end
  end

  def duplicate_vote?(user, direction)
    last_vote(user)&.direction == direction
  end

  def last_vote(user)
    votes.find_by(user: user.id) if user.present?
  end
end
