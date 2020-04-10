require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe 'best!' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer_one) { create(:answer, question: question, author: author) }
    let!(:answer_two) { create(:answer, question: question, author: author, best: true) }

    before { answer_one.best! }

    it 'marks chosen answer as best' do
      answer_one.reload

      expect(answer_one).to be_best
    end

    it 'marks other answers as not best' do
      answer_two.reload

      expect(answer_two).to_not be_best
    end
  end

end
