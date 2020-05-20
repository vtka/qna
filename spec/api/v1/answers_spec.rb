require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { {
    "CONTENT_TYPE" => "application/json",
    "ACCEPT" => "application/json"
  } }

  let(:access_token) { create :access_token }
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let!(:answers) { create_list :answer, 3, author: user, question: question }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_response.size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at author_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at author_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end
end
