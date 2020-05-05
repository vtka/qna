require 'rails_helper'

feature 'User can create answers', %q{
  In order to get help community
  As an authenticated user
  I'd like to be able to answer a question directly on its page
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path
      click_on question.title
    end

    scenario 'answers a question' do
      fill_in 'Your answer', with: 'Text text text'
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content 'Text text text'
      end
    end

    scenario 'answers a question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers a question with attached files' do
      fill_in 'Your answer', with: 'Text text text'

      within '.new-answer' do
        attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], visible: false
        click_on 'Answer'
      end

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit questions_path
    click_on question.title

    expect(page).to_not have_content 'Answer'
  end
end
