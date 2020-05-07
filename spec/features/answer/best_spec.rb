require 'features_helper'

feature 'User can choose the best answer', %q{
  In order to appreciate the help of other users
  And help community spot the best answer right away,
  As an author of the question
  I'd like to be able to choose the best answer
} do
  
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:other_question) { create(:question, author_id: users.last.id) }
  given!(:answers) { create_list(:answer, 2, question: question, author_id: users.last.id) }
  given!(:other_answers) { create_list(:answer, 2, question: other_question, author_id: users.first.id) }

  scenario 'Unauthenticated user can not choose best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Best answer'
    end
  end

  describe 'Authenticated user', js: true do
    describe 'as an author of the question' do
      background do
        sign_in(users.first)

        visit question_path(question)
      end
      
      scenario 'chooses best answer within authored question' do
        within "#answer-#{answers.last.id} .answer-content" do
          click_on 'Best answer'

          expect(page).to_not have_link 'Best answer'
        end

        within "#answer-#{answers.first.id}" do
          expect(page).to have_link 'Best answer'
        end

        within '.answers' do
          expect(page).to have_css('.best', count: 1)
          page.find("#answer-#{answers.last.id}").has_css?(".best")
        end
      end
    end

    describe 'as not an author of the question' do
      background do
        sign_in(users.first)

        visit question_path(other_question)
      end

      scenario "chooses best answer within other user's question" do
        within ".answers" do
          expect(page).to_not have_link 'Best answer'
        end
      end
    end
  end

end