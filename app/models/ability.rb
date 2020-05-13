# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities 
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], author: user
    can :destroy, [Question, Answer], author: user

    can :positive, [Question, Answer], votable: { author: user }
    can :negative, [Question, Answer], votable: { author: user }
    can :revote, [Question, Answer], votable: { author: user }

    can :best, Answer, question: { author: user }
    can :manage, Link, linkable: { author: user }
    can :manage, ActiveStorage::Attachment do |attachment|
      user.author? attachment.record
    end
  end
end
