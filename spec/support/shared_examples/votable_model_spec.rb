require 'rails_helper'

RSpec.shared_examples 'VotableModel' do
  let!(:users) { create_list(:user, 3) }

  context 'user is author of a resource' do
    it 'upvote' do
      model.upvote(model.author)
      model.reload

      expect(model.votecount).to eq(1)
    end

    it 'downvote' do
      model.downvote(model.author)
      model.reload

      expect(model.votecount).to eq(1)
    end
  end

  context 'user is not an author of a resource' do
    it 'upvote' do
      model.upvote(users.last)
      model.reload

      expect(model.votecount).to eq(2)
    end

    it 'downvote' do
      model.downvote(users.last)
      model.reload

      expect(model.votecount).to eq(0)
    end
  end

  it 'votecount' do
    model.upvote(users[1])
    model.upvote(users[2])
    model.reload

    expect(model.votecount).to eq(3)
  end
end
