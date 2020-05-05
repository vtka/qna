require 'rails_helper'

feature 'User can delete answers', %q{
  In order to remove unneeded information
  As an authenticated user and answer's author
  I'd like to be able to delete my own answers
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:answer) { create(:answer, question: question, author_id: users.first.id) }

  describe 'Authenticated user', js: true do
    scenario 'tries to delete their own answer' do
      sign_in(users.first)
      visit questions_path
      click_on question.title

      within '.answer-author-links' do
        click_on 'Delete'
      end

      # Accept pop-up alert
      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete other user's answer" do
      sign_in(users.last)
      visit questions_path
      click_on question.title

      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete any answer' do
    visit questions_path
    click_on question.title

    expect(page).to_not have_link 'Delete'
  end
end
