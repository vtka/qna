require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:question_one) { create(:question, author: user) }
    let!(:question_two) { create(:question, author: user) }
    let!(:award_one) { create(:award, question: question_one, recipient: user) }
    let!(:award_two) { create(:award, question: question_two, recipient: user) }

    before do
      log_in(user)
      get :index
    end

    it 'creates and populates an array of user awards' do
      expect(controller.awards).to match_array(user.awards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
