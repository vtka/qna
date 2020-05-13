require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, author: user, question: question }

    let(:other) { create :user }
    let(:other_question) { create :question, author: other }
    let(:other_answer) { create :answer, author: other, question: other_question }
    
    context 'general abilities' do
      it { should_not be_able_to :manage, :all }
      it { should be_able_to :read, :all }
    end

    context 'to create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'to update' do
      context 'authored resource' do
        it { should be_able_to :update, question, author: user }
        it { should be_able_to :update, answer, author: user }
      end

      context 'other resource' do
        it { should_not be_able_to :update, other_question, author: user }
        it { should_not be_able_to :update, other_answer, author: other, author: user }
      end
    end

    context 'to destroy' do
      context 'authored resource' do
        it { should be_able_to :destroy, question, author: user }
        it { should be_able_to :destroy, answer, author: user }
      end

      context 'other resource' do
        it { should_not be_able_to :destroy, other_question, author: user }
        it { should_not be_able_to :destroy, other_answer, author: other, author: user }
      end
    end
  end
end