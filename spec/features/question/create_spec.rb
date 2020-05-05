require 'rails_helper'

feature 'User can create questions', %q{
  In order to get answers from community
  As an authenticated user
  I'd like to be able to ask a question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask a question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'

      within '#files' do
        attach_file 'Attach files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with assigned award' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'

      within '#award' do
        fill_in 'Award title', with: 'Award'
        attach_file 'Attach image', "#{Rails.root}/spec/support/files/image.png"
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_css '.award'
    end

    scenario 'tries to ask a question with an award but does not fully fill out form' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Description', with: 'Text text text'

      within '#award' do
        fill_in 'Award title', with: 'Award'
      end

      click_on 'Ask'

      expect(page).to_not have_content 'Your question was successfully created.'
      expect(page).to_not have_css '.award'
      expect(page).to have_content 'Award image must be attached'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask a question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
