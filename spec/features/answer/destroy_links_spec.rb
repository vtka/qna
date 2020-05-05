require 'rails_helper'

feature 'User can delete answer links', %q{
  In order to remove unneeded information
  As an authenticated user and answer's author
  I'd like to be able to delete links attached to my answer
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:answer) { create(:answer, question: question, author_id: users.first.id) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user' do
    scenario 'tries to delete link on their own answer', js: true do
      sign_in(users.first)
      visit questions_path
      click_on question.title

      within '.answers .links' do
        click_on 'Delete'
      end

      # Accept pop-up alert
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Katata Games', href: 'http://katatagames.com'
    end

    scenario "tries to delete link on other user's answer", js: true do
      sign_in(users.last)
      visit questions_path
      click_on question.title

      within '.answers .links' do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete link on any answer', js: true do
    visit questions_path
    click_on question.title

    within '.answers .links' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
