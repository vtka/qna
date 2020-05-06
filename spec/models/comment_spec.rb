require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:author) }
  end

  describe 'validations' do
   it { should validate_presence_of :body }
  end
end