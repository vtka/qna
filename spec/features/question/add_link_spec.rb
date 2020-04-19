require 'features_helper'

feature 'User can add link question', %q{
    In order to add additional info
    As author of the question
    I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vtka/4ce6bc87f64e171076c9ac2fb423f6cc' }

  scenario 'User adds link to question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

end
