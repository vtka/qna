require 'rails_helper'

RSpec.shared_examples 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:author) { create(:user) }
  let(:users) { create_list(:user, 3) }
  let!(:model) { described_class }

  let(:votable) do
    if model.to_s == 'Answer'
      question = create(:question, author: author)
      create(model.to_s.underscore.to_sym, question: question, author: author)
    else
      create(model.to_s.underscore.to_sym, author: author)
    end
  end

  describe 'Vote Positive' do
    before { votable.positive(users.first) }

    it 'changed score' do
      expect(Vote.last.score).to eq 1
    end

    it 'vote user is a voter' do
      expect(Vote.last.user).to eq users.first
    end

    it 'votable is a votable' do
      expect(Vote.last.votable).to eq votable
    end
  end

  describe 'Vote Negative' do
    before { votable.negative(users.first) }

    it 'changed score' do
      expect(Vote.last.score).to eq -1
    end

    it 'vote user is a voter' do
      expect(Vote.last.user).to eq users.first
    end

    it 'votable is a votable' do
      expect(Vote.last.votable).to eq votable
    end
  end

  it 'check rating score' do
    users.each { |user| votable.positive(user) }

    expect(votable.rating).to eq 3
  end
end