require 'features_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes,
  As an author of the question
  I'd like to be able to edit my question
} do
  
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Authenticated user', js: true do
    describe do
      background do
        sign_in(users.first)
  
        visit question_path(question)
      end
      
      scenario 'edits his question' do
        within '.question' do
          click_on 'Edit'
          fill_in 'Edit your question', with: 'Edited question'
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'Edited question'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits question with attached files' do
        within '.question' do
          click_on 'Edit'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edits question with invalid params' do
        within '.question' do
          click_on 'Edit'
          fill_in 'Edit your question', with: ''
          click_on 'Save'

          expect(page).to have_content question.body
          expect(page).to have_selector 'textarea'
        end
      end
    end
    scenario "tries to edit other user's question" do
      sign_in(users.last)
      visit question_path(question)
      
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end