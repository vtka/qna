require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create :user }
  let(:user) { create :user }
  let(:question) { create :question, author: author }
  let(:answer) { create :answer, question: question, author: author }

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
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy views' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
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

  describe 'PATCH #update' do
    before { login author }
    
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'New body'
      end

      it 'renders update views' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

          answer.reload
        end.to_not change(answer, :body)
      end

      it 'renders update views' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    context 'as the author of the question' do
      before do
        sign_in(author)
        patch :best, params: { id: answer }, format: :js
      end

      it 'changes best attribute of an answer to true' do
        answer.reload

        expect(answer).to be_best
      end

      it 'renders best view' do
        expect(response).to render_template :best
      end
    end

    context 'as another user' do
      before do
        sign_in(user)
        patch :best, params: { id: answer }, format: :js
      end

      it 'does not change best attribute of an answer to true' do
        answer.reload

        expect(answer).not_to be_best
      end

      it 'renders best view' do
        expect(response).to render_template :best
      end
    end
  end

end
