require 'features_helper'

feature 'User can add link question', %q{
    In order to add additional info
    As author of the question
    I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vtka/4ce6bc87f64e171076c9ac2fb423f6cc' }
  given(:google_url) { 'https://www.google.kz/' }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text text'
  end

  scenario 'User adds valid link to question' do
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds invalid link to question', js: true do
    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: 'invalid link'
    end

    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
    expect(page).to_not have_link 'My gist', href: 'invalid link'
  end

  scenario 'User adds multiple links to question', js: true do
    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url
    end

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My google'
      fill_in 'URL', with: google_url
    end

    click_on 'Ask'

    within '.question' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My google', href: google_url
    end
  end

end
