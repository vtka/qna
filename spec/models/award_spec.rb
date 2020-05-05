require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:recipient).class_name('User').optional }
  it { should validate_presence_of :title }

  it 'has one attached image' do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe 'Methods' do
    describe 'validate_image_presence' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let(:award) { build(:award, question: question) }
      let(:award_without_image) { build(:award, :without_image, question: question) }

      it 'should keep object valid if image is attached' do
        expect(award).to be_valid
      end

      it 'should make object invalid if there is no image attached' do
        expect(award_without_image).to be_invalid
      end
    end
  end
end
