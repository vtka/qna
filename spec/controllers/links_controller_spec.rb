require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }

  before { login(author) }

  describe 'DELETE #destroy' do
    context 'question' do
      let!(:question_link) { create(:link, linkable: question) }

      context 'user is author' do
        it 'deletes a link' do
          expect { delete :destroy, params: { id: question_link.id }, format: :js }.to change(question.links, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: question_link.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not the author of the question' do
        let(:user) { create(:user) }

        before { login(user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: question_link.id }, format: :js }.not_to change(question.links, :count)
        end

        it 'returns 302 head' do
          delete :destroy, params: { id: question_link.id }, format: :js
          expect(response.status).to eq(302)
        end
      end
    end

    context 'answer' do
      let!(:answer_link) { create(:link, linkable: answer) }

      let(:answer) { create(:answer, :with_file, question: question, author: author) }

      context 'user is author' do
        it 'deletes an attachment' do
          expect { delete :destroy, params: { id: answer_link.id }, format: :js }.to change(answer.links, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: answer_link.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not the author of the answer' do
        let(:user) { create(:user) }

        before { login(user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: answer_link.id }, format: :js }.not_to change(answer.links, :count)
        end

        it 'returns 302 head' do
          delete :destroy, params: { id: answer_link.id }, format: :js
          expect(response.status).to eq(302)
        end
      end
    end
  end
end
