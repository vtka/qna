require 'rails_helper'

feature 'User can create answer', %q{
    In order to provide answer for the community
    As an authenticated user
    I'd like to be able to answer questions
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'gives answer' do
      fill_in 'Body', with: 'Text text text'
      click_on 'Answer'

      expect(page).to have_content 'Your answer was successfully created.'
      expect(page).to have_content 'Text text text'
    end

    scenario 'give answer with invalid params' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).to_not have_content 'Answer'
  end

end
