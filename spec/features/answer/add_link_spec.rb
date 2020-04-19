require 'features_helper'

feature 'User can add link answer', %q{
    In order to add additional info
    As author of the answer
    I'd like to be able to add links
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/vtka/4ce6bc87f64e171076c9ac2fb423f6cc' }
  given(:google_url) { 'https://www.google.kz/' }

  background do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Text text text'
  end

  scenario 'User adds valid link to answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User adds invalid link to answer', js: true do
    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: 'invalid link'
    end

    click_on 'Answer'

    within '.answer-errors' do
      expect(page).to have_content 'Links url is not a valid URL'
    end

    expect(page).to_not have_link 'My gist', href: 'invalid link'
  end

  scenario 'User adds multiple links to answer', js: true do
    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url
    end

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My google'
      fill_in 'URL', with: google_url
    end

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My google', href: google_url
    end
  end

end
