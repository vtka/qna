require 'features_helper'

feature 'User can see question list in order to find answers' do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, author: user) }

  scenario 'Authenticated user sees list of all questions' do
    sign_in(user)
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end

  scenario 'Unauthenticated user sees list of all questions' do
    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }
  end

end
