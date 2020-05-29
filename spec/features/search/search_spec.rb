require 'sphinx_helper.rb'

feature 'User can search within records', %q(
  In order to find information of interest
  As any user or guest
  I'd like to be able to search records by keywords
), js: true, sphinx: true do

  given!(:questions) { create_list(:question, 3) }
  given!(:question) { questions.first }
  given!(:answers) { create_list(:answer, 3)}
  given!(:answer) { answers.first }
  given!(:users) { create_list(:user, 3)}
  given!(:user) { users.first }
  given!(:comments) { create_list :comment, 3, author: user, commentable: question }
  given!(:comment) { comments.first }

  describe 'Unauthenticated user searches for record with' do
    before { visit root_path }

    scenario 'empty query' do
      ThinkingSphinx::Test.run do
        # save_and_open_screenshot
        find(:css, '.search-button').click

        expect(page).to_not have_content 'Search results'
      end
    end

    describe 'valid query' do
      scenario 'which does not match anything' do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: 'abcdefg'
          find(:css, '.search-button').click

          expect(page).to have_content 'Search results'

          within '.search-results' do
            expect(page).to have_content 'Your search - abcdefg - did not match any documents'
          end
        end
      end

      scenario 'which does match Question records in All scope' do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: question.title
          find(:css, '.search-button').click

          expect(page).to have_content 'Search results'

          within '.search-results' do
            expect(page).to have_content question.title
            expect(page).to have_content question.body.truncate(160)
            questions.drop(1).each do |q|
              expect(page).to_not have_content q.title
            end
          end
        end
      end

      scenario 'which does match Question records' do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: question.title
          find('#scope', :text => 'Questions').click
          find(:css, '.search-button').click

          expect(page).to have_content 'Search results'

          within '.search-results' do
            expect(page).to have_content question.title
            expect(page).to have_content question.body.truncate(160)
            questions.drop(1).each do |q|
              expect(page).to_not have_content q.title
            end
          end
        end
      end

      scenario 'which does match Answer records' do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: answer.body
          find('#scope', :text => 'Answers').click
          find(:css, '.search-button').click

          expect(page).to have_content 'Search results'

          within '.search-results' do
            expect(page).to have_content answer.body.truncate(160)
            answers.drop(1).each do |q|
              expect(page).to_not have_content q.body
            end
          end
        end
      end

      scenario 'which does match User records' do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: user.email
          find('#scope', :text => 'Users').click
          find(:css, '.search-button').click

          expect(page).to have_content 'Search results'

          within '.search-results' do
            expect(page).to have_content user.email
            users.drop(1).each do |q|
              expect(page).to_not have_content q.email
            end
          end
        end
      end

      scenario 'which does match Comment records' do
        ThinkingSphinx::Test.run do
          fill_in 'Search', with: comment.body
          find('#scope', :text => 'Comments').click
          find(:css, '.search-button').click

          expect(page).to have_content 'Search results'

          within '.search-results' do
            expect(page).to have_content comment.body.truncate(160)
            comments.drop(1).each do |q|
              expect(page).to_not have_content q.body
            end
          end
        end
      end
    end
  end
end
