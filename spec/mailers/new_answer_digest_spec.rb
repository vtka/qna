require "rails_helper"

RSpec.describe NewAnswerDigestMailer, type: :mailer do
  describe 'New answer digest' do
    let(:users) { create_list :user, 3 }
    let(:user) { users.first }
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, question: question, author: users.last }
    let(:mail) { NewAnswerDigestMailer.send_for(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq("New Answer for question #{answer.question.title}")
      expect(mail.to).to eq [question.author.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end  
end
