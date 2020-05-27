require 'sphinx_helper.rb'

feature 'User can search within records', %q(
  In order to find information of interest
  As any user or guest
  I'd like to be able to search records by keywords
), js: true, sphinx: true do

  given!(:questions) { create_list(:question, 3) }
  given!(:question) { questions.first }

  describe 'Unauthenticated user searches for question with' do
    before { visit root_path }

    scenario 'empty query' do
      ThinkingSphinx::Test.run do
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

      scenario 'which does match records' do
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
    end
  end
end
