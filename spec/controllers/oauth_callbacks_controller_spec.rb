require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  Devise.omniauth_providers.each do |provider|
    describe provider.to_s.capitalize do
      let(:oauth_data) { oauth_response(provider: provider) }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with("omniauth.auth").and_return(oauth_data)
      end

      it 'finds user from oauth data' do
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get provider
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get provider
        end

        it 'logs in user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        it 'creates user' do
          expect { get provider }.to change(User, :count).by(1)
          expect(User.last.email).to eq (oauth_data.info[:email])
        end

        it 'redirects to root path' do
          get provider
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
