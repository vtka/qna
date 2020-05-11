require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

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
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
