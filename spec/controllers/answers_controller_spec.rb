require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'assigns a parent question to the answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'assigns an author to the answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
      end

      it "redirects to this answer's question's show view" do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders show questions view with a form to create an answer' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:users) { create_list(:user, 2) }
    let!(:answer) { create(:answer, question: question, author_id: users.first.id ) }

    context 'user is author' do
      before { sign_in(users.first) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'user is not an author' do
      before { login(users.last) }

      it 'does not delete an answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirects to 403 page' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response.status).to eq(403)
      end
    end
  end
end
