require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:awards).with_foreign_key('recipient_id').dependent(:nullify) }

  describe 'author_of?' do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, author: users.first) }

    it 'returns true if user is author of a resource' do
      expect(users.first).to be_author_of(question)
    end

    it 'returns false if user is not author of a resource' do
      expect(users.last).to_not be_author_of(question)
    end
  end
end
