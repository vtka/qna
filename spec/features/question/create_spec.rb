require 'features_helper'

feature 'User can create question', %q{
    In order to get answer from a community
    As an authenticated user
    I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'fills form with valid params' do
      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Text text text'
      end

      scenario 'asks question' do
        click_on 'Ask'

        expect(page).to have_content 'Your question was successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Text text text'
      end

      scenario 'asks question with attached files' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'asks question with badge attached' do
        within '.badge-fields' do
          fill_in 'Badge title', with: 'Some Bage Title'
          attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
        end
  
        click_on 'Ask'
  
        expect(page).to have_content 'Your question was successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Text text text'
        expect(page).to have_content 'Some Bage Title'
      end
    end

    scenario 'asks question with invalid params' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

  end

  scenario 'Unauthenticated user tries to ask question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
