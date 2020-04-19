require 'features_helper'

feature 'User can add link answer', %q{
    In order to add additional info
    As author of the answer
    I'd like to be able to add links
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/vtka/4ce6bc87f64e171076c9ac2fb423f6cc' }

  scenario 'User adds link to question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end
