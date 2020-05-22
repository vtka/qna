require 'rails_helper'

RSpec.describe NewAnswerDigestJob, type: :job do
  let(:users) { create_list :user, 2 }
  let(:question) { create :question, author: users.first }
  let(:answer) { create :answer, question: question, author: users.last }
  let(:service) { double('NewAnswerDigestService') }

  before { allow(NewAnswerDigestService).to receive(:new).and_return(service) }

  it 'calls NewAnswerDigestService#send_notification' do
    expect(service).to receive(:send_notification)
    NewAnswerDigestJob.perform_now(answer)
  end
end
