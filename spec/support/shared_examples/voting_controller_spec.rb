require 'rails_helper'

RSpec.shared_examples 'VotingController' do
  let(:users) { create_list(:user, 2) }

  describe 'PATCH #upvote' do
    context 'user is an author' do
      it 'does not upvote a resource' do
        log_in(model.author)

        expect do
          patch :upvote, params: { id: model }, format: :json
        end.to_not change(Vote, :count)

        expect(response).to have_http_status 403
        expect(model.votecount).to eq 1
      end
    end

    context 'user is not an author' do
      before do
        log_in(users.last)
      end

      context 'with no prior vote' do
        it 'upvotes a resource' do
          expect do
            patch :upvote, params: { id: model }, format: :json
          end.to change(Vote, :count).by(1)

          expect(model.votecount).to eq 2
        end
      end

      context 'with a prior downvote' do
        before do
          patch :downvote, params: { id: model }, format: :json
        end

        it 'upvotes a resource' do
          expect do
            patch :upvote, params: { id: model }, format: :json
          end.to_not change(Vote, :count)

          expect(model.votecount).to eq 2
        end
      end

      context 'with a prior upvote' do
        before do
          patch :upvote, params: { id: model }, format: :json
        end

        it 'does not upvote a resource' do
          expect do
            patch :upvote, params: { id: model }, format: :json
          end.to_not change(Vote, :count)

          patch :upvote, params: { id: model }, format: :json
          expect(response).to have_http_status 409
          expect(model.votecount).to eq 2
        end
      end
    end
  end

  describe 'PATCH #downvote' do
    context 'user is an author' do
      it 'does not downvote a resource' do
        log_in(model.author)

        expect do
          patch :downvote, params: { id: model }, format: :json
        end.to_not change(Vote, :count)

        expect(response).to have_http_status 403
        expect(model.votecount).to eq 1
      end
    end

    context 'user is not an author' do
      before do
        log_in(users.last)
      end

      context 'with no prior vote' do
        it 'downvotes a resource' do
          expect do
            patch :downvote, params: { id: model }, format: :json
          end.to change(Vote, :count).by(1)

          expect(model.votecount).to eq 0
        end
      end

      context 'with a prior upvote' do
        before do
          patch :upvote, params: { id: model }, format: :json
        end

        it 'downvotes a resource' do
          expect do
            patch :downvote, params: { id: model }, format: :json
          end.to_not change(Vote, :count)

          expect(model.votecount).to eq 0
        end
      end

      context 'with a prior downvote' do
        before do
          patch :downvote, params: { id: model }, format: :json
        end

        it 'does not downvote a resource' do
          expect do
            patch :downvote, params: { id: model }, format: :json
          end.to_not change(Vote, :count)

          expect(response).to have_http_status 409
          expect(model.votecount).to eq 0
        end
      end
    end
  end
end
