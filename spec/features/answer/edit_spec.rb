require 'features_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes,
  As an author of the answer
  I'd like to be able to edit my answer
} do
  
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:answer) { create(:answer, question: question, author_id: users.first.id) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(users.first)
      visit question_path(question)
      
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits answer with invalid params'
    scenario "tries to edit other user's answer"
  end
end