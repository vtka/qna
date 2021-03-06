require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, :with_file, author: author) }

  before { login(author) }

  describe 'DELETE #destroy' do
    context 'question' do
      context 'user is author' do
        it 'deletes an attachment' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not the author of the question' do
        let(:user) { create(:user) }

        before { login(user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.not_to change(question.files, :count)
        end

        it 'returns 403 head' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response.status).to eq(403)
        end
      end
    end

    context 'answer' do
      let(:answer) { create(:answer, :with_file, question: question, author: author) }

      context 'user is author' do
        it 'deletes an attachment' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'redirects to destroy view' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'not the author of the answer' do
        let(:user) { create(:user) }

        before { login(user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.not_to change(answer.files, :count)
        end

        it 'returns 403 head' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response.status).to eq(403)
        end
      end
    end
  end
end
