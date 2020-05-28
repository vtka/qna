require 'sphinx_helper'

RSpec.describe SearchService do
  context 'returns a correct result' do
    it 'which is a SearchResult object' do
      allow(ThinkingSphinx).to receive(:search).and_return([])
      result = SearchService.new(q: 'abcd', scope: 'All').call
      expect(result).to be_a SearchResult
    end

    it 'with correct attributes if no records are matched' do
      allow(ThinkingSphinx).to receive(:search).and_return([])
      result = SearchService.new(q: 'abcd', scope: 'All').call
      expect(result).to have_attributes(query: 'abcd', scope: 'All', content: [], count: 0)
    end

    context 'with correct attributes if records are matched' do
      let!(:question) { create(:question) }
      let!(:user) { create(:user) }
      let!(:comments) { create_list :comment, 3, author: user, commentable: question }

      it 'for Question in All scope' do
        questions = create_list(:question, 3)

        allow(ThinkingSphinx).to receive(:search).and_return(questions)
        result = SearchService.new(q: 'abcd', scope: 'All').call
        expect(result).to have_attributes(query: 'abcd', scope: 'All', content: questions, count: questions.count)
      end

      it 'for Question in Question scope' do
        questions = create_list(:question, 3)

        allow(ThinkingSphinx).to receive(:search).and_return(questions)
        result = SearchService.new(q: 'abcd', scope: 'Question').call
        expect(result).to have_attributes(query: 'abcd', scope: 'Question', content: questions, count: questions.count)
      end

      it 'for Answer in Answer scope' do
        answers = create_list(:answer, 3)

        allow(ThinkingSphinx).to receive(:search).and_return(answers)
        result = SearchService.new(q: 'abcd', scope: 'Answer').call
        expect(result).to have_attributes(query: 'abcd', scope: 'Answer', content: answers, count: answers.count)
      end

      it 'for User in User scope' do
        users = create_list(:user, 3)

        allow(ThinkingSphinx).to receive(:search).and_return(users)
        result = SearchService.new(q: 'abcd', scope: 'User').call
        expect(result).to have_attributes(query: 'abcd', scope: 'User', content: users, count: users.count)
      end

      it 'for Comment in Comment scope' do
        allow(ThinkingSphinx).to receive(:search).and_return(comments)
        result = SearchService.new(q: 'abcd', scope: 'Comment').call
        expect(result).to have_attributes(query: 'abcd', scope: 'Comment', content: comments, count: comments.count)
      end
    end
  end
end
