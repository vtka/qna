require 'rails_helper'

feature 'User can upvote or downvote an question', %(
  In order to rate quality of an question
  As an authenticated user
  I'd like to be able to upvote or downvote questions
) do

  given(:users) { create_list(:user, 2) }
  given!(:own_question) { create(:question, author: users.first) }
  given!(:another_question) { create(:question, author: users.last) }

  scenario 'Unauthenticated user can not upvote or downvote questions', js: true do
    visit question_path(another_question)

    within '.question' do
      click_on 'Upvote'

      within '.voting' do
        expect(page).to have_content '1'
      end

      click_on 'Downvote'

      within '.voting' do
        expect(page).to have_content '1'
      end
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(users[0])
    end

    scenario 'upvotes another user\'s question' do
      visit question_path(another_question)
      within '.question' do
        click_on 'Upvote'

        within '.votecount' do
          expect(page).to have_content '2'
        end
      end
    end

    scenario 'changes his vote to downvote' do
      visit question_path(another_question)
      within '.question' do
        click_on 'Upvote'
        click_on 'Downvote'

        within '.votecount' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'can\'t cast same vote twice' do
      visit question_path(another_question)
      within '.question' do
        click_on 'Upvote'

        within '.voting' do
          expect(page).to have_content '2'
        end
      end
    end

    scenario 'can\'t upvote or downvote his own question' do
      visit question_path(own_question)
      within '.question' do
        click_on 'Upvote'

        within '.voting' do
          expect(page).to have_content '1'
        end

        click_on 'Downvote'

        within '.voting' do
          expect(page).to have_content '1'
        end
      end
    end
  end
end
