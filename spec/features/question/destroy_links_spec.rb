require 'rails_helper'

feature 'User can delete question links', %q{
  In order to remove unneeded information
  As an authenticated user and questions's author
  I'd like to be able to delete links attached to my question
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user' do
    scenario 'tries to delete link on their own question', js: true do
      sign_in(users.first)
      visit questions_path
      click_on question.title

      within '.question .links' do
        click_on 'Delete'
      end

      # Accept pop-up alert
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_link 'Katata Games', href: 'http://katatagames.com'
    end

    scenario "tries to delete link on other user's question", js: true do
      sign_in(users.last)
      visit questions_path
      click_on question.title

      within '.question .links' do
        expect(page).to_not have_selector 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete link on any question', js: true do
    visit questions_path
    click_on question.title

    within '.question .links' do
      expect(page).to_not have_selector 'Delete'
    end
  end
end
