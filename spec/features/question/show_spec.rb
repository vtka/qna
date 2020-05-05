require 'rails_helper'

feature 'User can view a question with all answers to it', %q{
  In order to find an answer to a question I'm intersted in
  As a user
  I'd like to be able to see a question page with all answers to it listed
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question, author: user) }

  scenario 'Authenticated user sees a question with list of all answers' do
    sign_in(user)
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user sees a question with list of all answers' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
