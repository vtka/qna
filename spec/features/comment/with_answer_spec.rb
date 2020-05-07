require 'features_helper'

feature 'User can post a comment', %q{
  To any answer
  I'd like to be able to post comments
  For the answer
} do

  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, author: author }
  given!(:answer) { create :answer, question: question, author: author }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'posts a comment' do
      within '.answer-comments' do
        click_on 'Add comment'
        fill_in 'Your comment', with: 'Some Comment'
        click_on 'Post'
      end

      expect(page).to have_content 'Some Comment'
    end

    scenario 'posts a comment with errors' do
      within '.answer-comments' do
        click_on 'Add comment'
        fill_in 'Your comment', with: ''
        click_on 'Post'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Multiple sessions', js: true do
    scenario 'comment appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)

        within '.answer-comments' do
          click_on 'Add comment'
          fill_in 'Your comment', with: 'Some Comment'
          click_on 'Post'
        end

        expect(page).to have_content 'Some Comment'
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        expect(page).to have_content 'Some Comment'
      end
    end
  end
end