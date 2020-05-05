require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'gist?' do
    let(:user) { create(:user)}
    let(:question) { create(:question, author: user) }
    let(:gist_link) { create(:link, :gist, linkable: question) }
    let(:another_link) { create(:link, linkable: question) }

    it 'returns true if link is a gist' do
      expect(gist?(gist_link)).to be_truthy
    end

    it 'returns false if link is not a gist' do
      expect(gist?(another_link)).to be_falsey
    end
  end
end
