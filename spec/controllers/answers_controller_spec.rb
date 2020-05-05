require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before { log_in(user) }

  it_should_behave_like 'VotingController' do
    let(:model) { create :answer, question: question, author: user }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'assigns a parent question to the answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'assigns an author to the answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(user.answers, :count).by(1)
      end

      it "renders create template" do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:users) { create_list(:user, 2) }
    let!(:answer) { create(:answer, question: question, author_id: users.first.id ) }

    before { log_in(users.first) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'not the author of the answer' do
      let!(:answer_two) { create(:answer, question: question, author_id: users.last.id ) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer_two, answer: attributes_for(:answer) }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:users) { create_list(:user, 2) }
    let!(:answer) { create(:answer, question: question, author_id: users.first.id ) }

    context 'user is author' do
      before { sign_in(users.first) }

      it 'deletes the answer' do
        expect do
          delete :destroy, params: { id: answer, question_id: question }, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not an author' do
      before { sign_in(users.last) }

      it 'does not delete an answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirects to 403 page' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH #accept' do
    let!(:another_user) { create(:user) }
    let!(:answer) { create(:answer, question: question, author_id: user.id ) }
    let!(:award) { create(:award, question: question) }

    context 'as the author of the question' do
      before do
        sign_in(user)
        patch :accept, params: { id: answer }, format: :js
      end

      it 'changes accepted attribute of an answer to true' do
        answer.reload

        expect(answer).to be_accepted
      end

      it 'assigns answer\'s author a reward if there is one created' do
        expect(user.awards[0].question).to eq question
      end

      it 'renders accept view' do
        expect(response).to render_template :accept
      end
    end

    context 'as not the author of the question' do
      before do
        sign_in(another_user)
        patch :accept, params: { id: answer }, format: :js
      end

      it 'does not change accepted attribute of an answer to true' do
        answer.reload

        expect(answer).to_not be_accepted
      end

      it 'redirects to 403 page' do
        expect(response.status).to eq(403)
      end
    end
  end
end
