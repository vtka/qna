require 'features_helper'

feature 'User can delete link from question', %q{
    In order to add update info
    As author of the question
    I'd like to be able to delete my links
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'deletes link from question', js: true do
      within '.question .links' do
        click_on 'x'

        expect(page).not_to have_link link.name, href: link.url
      end
    end
  end

  describe 'User' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "deletes link of someone's answer", js: true do
      within '.question .links' do
        expect(page).not_to have_link 'x'

        expect(page).to have_link link.name, href: link.url
      end
    end
  end
end
