require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it_should_behave_like 'VotableModel' do
    let(:user) { create(:user) }
    let(:model) { create(:question, author: user) }
  end

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Methods' do
    describe 'give_award_to' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let!(:award) { create(:award, question: question) }

      it 'should assign this question\'s award to user' do
        question.give_award_to(user)

        expect(award.recipient).to eq user
      end
    end
  end
end
