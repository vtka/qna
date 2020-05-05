require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  before { log_in(user) }

  it_should_behave_like 'VotingController' do
    let(:model) { create :question, author: user }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { log_in(user) }

    before { get :show, params: { id: question } }

    it 'assigns a new empty link to an answer' do
      expect(@controller.answer.links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { log_in(user) }

    before { get :new }

    it 'assigns a new empty link to a question' do
      expect(@controller.question.links.first).to be_a_new(Link)
    end

    it 'assigns a new empty award to a question' do
      expect(@controller.question.award).to be_a_new(Award)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'assigns an author to the question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: '' } }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to_not eq 'new title'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'not the author of the question' do
      let(:user_two) { create(:user) }

      before { log_in(user_two) }

      it 'does not change question' do
        question.reload

        expect(question.title).to_not eq 'new title'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:users) { create_list(:user, 2) }
    let!(:question) { create(:question, author_id: users.first.id ) }

    context 'user is author' do
      before { sign_in(users.first) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not an author' do
      before { sign_in(users.last) }

      it 'does not delete a question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to 403 page' do
        delete :destroy, params: { id: question }
        expect(response.status).to eq(403)
      end
    end
  end
end
