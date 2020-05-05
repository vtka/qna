require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before { log_in(user) }

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question_link) { create(:link, linkable: question) }

      context 'user is author' do
        it 'deletes link' do
          expect { delete :destroy, params: { id: question_link.id }, format: :js }.to change(question.links, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: question_link.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not the author of the question' do
        let(:user_two) { create(:user) }

        before { log_in(user_two) }

        it 'does not delete link' do
          expect { delete :destroy, params: { id: question_link.id }, format: :js }.not_to change(question.links, :count)
        end

        it 'returns 403 head' do
          delete :destroy, params: { id: question_link.id }, format: :js
          expect(response.status).to eq(403)
        end
      end
    end

    context 'answer' do
      let(:answer) { create(:answer, question: question, author: user) }
      let!(:answer_link) { create(:link, linkable: answer) }

      context 'user is author' do
        it 'deletes link' do
          expect { delete :destroy, params: { id: answer_link.id }, format: :js }.to change(answer.links, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: answer_link.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not the author of the answer' do
        let(:user_two) { create(:user) }

        before { log_in(user_two) }

        it 'does not delete link' do
          expect { delete :destroy, params: { id: answer_link.id }, format: :js }.not_to change(answer.links, :count)
        end

        it 'returns 403 head' do
          delete :destroy, params: { id: answer_link.id }, format: :js
          expect(response.status).to eq(403)
        end
      end
    end
  end
end
