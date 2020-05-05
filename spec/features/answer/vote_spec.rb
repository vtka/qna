require 'rails_helper'

feature 'User can upvote or downvote an answer', %(
  In order to rate quality of an answer
  As an authenticated user
  I'd like to be able to upvote or downvote answers
) do

  given(:users) { create_list(:user, 2) }
  given!(:questions) { create_list(:question, 2, author_id: users.first.id) }
  given!(:own_answer) { create(:answer, question: questions[0], author_id: users[0].id) }
  given!(:another_answer) { create(:answer, question: questions[1], author_id: users[1].id) }

  scenario 'Unauthenticated user can not upvote or downvote answers', js: true do
    visit question_path(questions[1])

    within '.answers' do
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

    scenario 'upvotes another user\'s answer' do
      visit question_path(questions[1])
      within '.answers' do
        click_on 'Upvote'

        expect(page).to have_content '2'
      end
    end

    scenario 'changes his vote to downvote' do
      visit question_path(questions[1])
      within '.answers' do
        click_on 'Upvote'
        click_on 'Downvote'

        expect(page).to have_content '0'
      end
    end

    scenario 'can\'t cast same vote twice' do
      visit question_path(questions[1])
      within '.answers' do
        click_on 'Upvote'
        click_on 'Upvote'

        within '.voting' do
          expect(page).to have_content '2'
        end
      end
    end

    scenario 'can\'t upvote or downvote his own answer' do
      visit question_path(questions[0])
      within '.answers' do
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
