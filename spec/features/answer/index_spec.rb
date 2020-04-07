require 'features_helper'

feature 'User can see question\s answer list list in order to find suitable answers' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, author: user, question: question) }

  scenario 'Authenticated user sees list of all answers' do
    sign_in(user)
    visit question_path(question)

    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user sees list of all answers' do
    visit question_path(question)
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
