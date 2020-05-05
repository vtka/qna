require 'rails_helper'

feature 'User can accept one answer to their question', %q{
  In order to select the best answer to my question
  As an author of the question
  I'd like to be able to accept one answer to my question
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: users.first.id) }
  given!(:answers) { create_list(:answer, 2, question: question, author_id: users.first.id) }

  scenario 'Unauthenticated can not accept answers' do
    visit questions_path
    click_on question.title

    expect(page).to_not have_link 'Accept'
  end

  describe 'Authenticated user', js: true do
    describe 'as the author of the question' do
      scenario 'accepts an answer' do
        sign_in(users.first)
        visit questions_path
        click_on question.title

        within "#answer-#{answers.last.id}" do
          click_on 'Accept this answer'

          # Accept pop-up alert
          page.driver.browser.switch_to.alert.accept

          expect(page).to_not have_link 'Accept this answer'
        end

        expect(page).to have_css('.accepted', count: 1)
        expect(answers.last.body).to appear_before(answers.first.body)
      end

      scenario 'accepts another answer' do
        sign_in(users.first)
        visit questions_path
        click_on question.title

        within "#answer-#{answers.last.id}" do
          click_on 'Accept this answer'

          # Accept pop-up alert
          page.driver.browser.switch_to.alert.accept
        end

        within "#answer-#{answers.first.id}" do
          click_on 'Accept this answer'

          # Accept pop-up alert
          page.driver.browser.switch_to.alert.accept

          expect(page).to_not have_link 'Accept this answer'
        end

        expect(page).to have_css('.accepted', count: 1)
        expect(answers.first.body).to appear_before(answers.last.body)
      end
    end

    describe 'as not the author of the question' do
      scenario 'can not accept an answer' do
        sign_in(users.last)
        visit questions_path
        click_on question.title

        expect(page).to_not have_link 'Accept'
      end
    end
  end
end
