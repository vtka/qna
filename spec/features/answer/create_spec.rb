require 'features_helper'

feature 'User can create answer', %q{
    In order to provide answer for the community
    As an authenticated user
    I'd like to be able to answer questions
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'gives answer' do
      fill_in 'Your answer', with: 'Text text text'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Text text text'
      end
    end

    scenario 'gives answer with attached files' do
      fill_in 'Your answer', with: 'Text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Text text text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'gives answer with invalid params' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank" 
    end

  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).to_not have_content 'Answer'
  end

end
