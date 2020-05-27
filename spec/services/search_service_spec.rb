require 'rails_helper'

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

    it 'with correct attributes if records are matched' do
      questions = create_list(:question, 3)

      allow(ThinkingSphinx).to receive(:search).and_return(questions)
      result = SearchService.new(q: 'abcd', scope: 'All').call
      expect(result).to have_attributes(query: 'abcd', scope: 'All', content: questions, count: questions.count)
    end
  end
end
