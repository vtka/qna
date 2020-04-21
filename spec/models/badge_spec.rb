require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  it 'has one attached image' do
    expect(Badge.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
