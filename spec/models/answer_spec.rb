require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it_should_behave_like 'VotableModel' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:model) { create :answer, question: question, author: user }
  end

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Methods' do
    describe 'accept!' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, author_id: user.id) }
      let!(:answer_one) { create(:answer, question: question, author_id: user.id) }
      let!(:answer_two) { create(:answer, question: question, author_id: user.id, accepted: true) }

      before { answer_one.accept! }

      it 'marks chosen answer as accepted' do
        answer_one.reload

        expect(answer_one).to be_accepted
      end

      it 'marks other questions as not accepted' do
        answer_two.reload

        expect(answer_two).to_not be_accepted
      end
    end
  end
end
