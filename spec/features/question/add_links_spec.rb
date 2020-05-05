require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:katata_url) { 'http://katatagames.com/' }
  given(:katata_blog_url) { 'http://katatagames.com/category/blog/' }

  background do
    sign_in(user)
    visit questions_path
    click_on 'Ask a question'
  end

  describe 'User adds a regular link when asking a question' do
    scenario 'it is a vallid link', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'

      within all('#links .nested-fields').last do
        fill_in 'Link name', with: 'Katata Games'
        fill_in 'URL', with: katata_url
      end

      click_on 'Add link'

      within all('#links .nested-fields').last do
        fill_in 'Link name', with: 'Katata Games Blog'
        fill_in 'URL', with: katata_blog_url
      end

      click_on 'Ask'

      expect(page).to have_link 'Katata Games', href: katata_url
      expect(page).to have_link 'Katata Games Blog', href: katata_blog_url
    end

    scenario 'it is an invalid link', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'

      within all('#links .nested-fields').last do
        fill_in 'Link name', with: 'Katata Games'
        fill_in 'URL', with: 'invalid link'
      end

      click_on 'Ask'

      expect(page).to have_content 'Links url is not a valid URL'
      expect(page).to_not have_link 'Katata Games', href: 'invalid link'
      expect(page).to_not have_content 'Question successfully created'
    end
  end

  describe 'User adds a link to Github Gist when asking a question' do
    given(:gist_url) { 'https://gist.github.com/dersnek/2880c576b8e5912b7c0b8ea6a6fcff82' }
    given(:invalid_gist_url) { 'https://gist.github.com/dersnek/000' }

    scenario 'it is a valid Gist link', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'

      within all('#links .nested-fields').last do
        fill_in 'Link name', with: 'SQL Gist'
        fill_in 'URL', with: gist_url
      end

      click_on 'Ask'

      wait_for_ajax
      expect(page).to have_content 'postgres=# CREATE DATABASE test_guru;'
      expect(page).to have_link 'SQL Gist', href: gist_url
    end

    scenario 'it is an invalid Gist link', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'

      within all('#links .nested-fields').last do
        fill_in 'Link name', with: 'Invalid Gist'
        fill_in 'URL', with: invalid_gist_url
      end

      click_on 'Ask'

      wait_for_ajax
      expect(page).to have_content 'Cannot load Gist.'
      expect(page).to have_link 'Invalid Gist', href: invalid_gist_url
    end
  end
end
