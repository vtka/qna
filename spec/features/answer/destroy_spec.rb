require 'features_helper'

feature 'User can delete own answers', %q{
    In order to remove an outdated information
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:answer) { create(:answer, question: question, author_id: users.first.id) }

  describe 'Authenticated user', js: true do

    scenario 'deletes own answer' do
      sign_in(users.first)
      visit question_path(question)

      within '.deleteAnswer' do
        click_on 'Delete'
      end
      
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete another user's answer" do
      sign_in(users.last)
      visit question_path(question)

      expect(page).to_not have_selector '.deleteAnswer'
    end

  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_selector '.deleteAnswer'
  end

end
