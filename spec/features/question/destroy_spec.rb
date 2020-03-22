require 'rails_helper'

feature 'User can delete own questions', %q{
    In order to remove an outdated information
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }

  describe 'Authenticated user' do

    scenario 'deletes own question' do
      sign_in(users.first)
      visit questions_path
      click_on 'View'

      within '.deleteQuestion' do
        click_on 'Delete'
      end

      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario "tries to delete another user's question" do
      sign_in(users.last)
      visit questions_path
      click_on 'View'

      expect(page).to_not have_selector '.deleteQuestion'
    end

  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'View'

    expect(page).to_not have_selector '.deleteQuestion'
  end

end
