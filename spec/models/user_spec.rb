require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  let(:author) { create :user }
  let(:user) { create :user }
  let(:question) { create :question, author: author }
  let(:answer) { create :answer, question: question, author: author }

  describe 'User is an author' do
    it 'of the question' do
      expect(author).to be_author(question)
    end

    it 'of the answer' do
      expect(author).to be_author(answer)
    end
  end

  describe 'User is not an author' do
    it 'of the question' do
      expect(user).to_not be_author(question)
    end

    it 'of the answer' do
      expect(user).to_not be_author(answer)
    end
  end

  describe 'User voted positive' do
    before { question.positive(user) }

    it 'for the question' do
      expect(user).to be_voted(question)
    end
  end

  describe 'User voted negative' do
    before { question.negative(user) }

    it 'for the question' do
      expect(user).to be_voted(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    context 'user already has authorization' do
       it 'returns the user' do
         user.authorizations.create(provider: 'github', uid: '123456')
         expect(User.find_for_oauth(auth)).to eq user
       end
    end

    context 'user does not have authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email}) }

        it 'should not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations , :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid 
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com'}) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)

          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization' do
          user = User.find_for_oauth(auth)

          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid 
        end
      end
    end
  end
end
