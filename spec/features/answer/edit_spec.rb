require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:answer) { create(:answer, question: question, author_id: users.first.id) }

  scenario 'Unauthenticated user can not edit answer' do
    visit questions_path
    click_on question.title

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(users.first)
      visit questions_path
      click_on question.title
      within '.answers' do
        click_on 'Edit'
      end
    end

    scenario 'edits his answer' do
      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his answer with attached files' do
      within '.answers' do
        attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], visible: false
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'removes previously attached file from his question' do
      within '.answers' do
        attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb"], visible: false
        click_on 'Save'

        within '.files' do
          click_on 'Delete'
        end
      end

      # Accept pop-up alert
      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'edits his answer with attached links', js: true do
      within '.answers' do
        click_on 'Add link'

        within all('#links .nested-fields').last do
          fill_in 'Link name', with: 'Katata Games'
          fill_in 'URL', with: 'http://katatagames.com'
        end

        click_on 'Add link'

        within all('#links .nested-fields').last do
          fill_in 'Link name', with: 'Katata Games Blog'
          fill_in 'URL', with: 'http://katatagames.com/category/blog/'
        end

        click_on 'Save'

        expect(page).to have_link 'Katata Games'
        expect(page).to have_link 'Katata Games Blog'
      end
    end

    scenario 'edits his answer with a Gist links', js: true do
      within '.answers' do
        click_on 'Add link'

        within all('#links .nested-fields').last do
          fill_in 'Link name', with: 'SQL Gist'
          fill_in 'URL', with: 'https://gist.github.com/dersnek/2880c576b8e5912b7c0b8ea6a6fcff82'
        end

        click_on 'Save'

        wait_for_ajax
        sleep 1.second
        expect(page).to have_content 'postgres=# CREATE DATABASE test_guru;'
        expect(page).to have_link 'SQL Gist', href: 'https://gist.github.com/dersnek/2880c576b8e5912b7c0b8ea6a6fcff82'
      end
    end

    scenario "tries to edit other user's answer" do
      sign_out
      sign_in(users.last)
      visit questions_path
      click_on question.title

      expect(page).to_not have_link 'Edit'
    end
  end
end
