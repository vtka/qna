require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { {
    "CONTENT_TYPE" => "application/json",
    "ACCEPT" => "application/json"
  } }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { me_api_v1_profiles_path }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before {
        get api_path, params: { access_token: access_token.token }, headers: headers 
      }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json["user"][attr]).to eq me.send(attr).as_json
        end
      end

      it 'dosn\'t return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { users.first }
      let(:user) { users.last }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list :user, 3 }
      let(:users_response) { json['users'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns all users without me' do
        expect(users_response.size).to eq 2
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(users_response.last[attr]).to eq user.send(attr).as_json
        end
      end

      it 'dosn\'t return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(users_response.last).to_not have_key(attr)
        end
      end
    end
  end
end