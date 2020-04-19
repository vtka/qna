require 'features_helper'

feature 'User can add new links to answer', %q{
    In order to add additional info
    As author of the answer
    I'd like to be able to add new links
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }
  given!(:link) { create(:link, linkable: answer) }
  given(:google_url) { 'https://www.google.kz/' }
  given(:gist_url) { 'https://gist.github.com/vtka/4ce6bc87f64e171076c9ac2fb423f6cc' }

  background do
    sign_in(author)
    visit question_path(question)
  end

  scenario 'User adds new valid link to answer', js: true do
    within '.answers' do
      click_on 'Edit'
      click_on 'add link'

      fill_in 'Link name', with: 'My google'
      fill_in 'URL', with: google_url

      click_on 'Save'

      expect(page).to have_link link.name, href: link.url
      expect(page).to have_link 'My google', href: google_url
    end
  end

  scenario 'User adds invalid link to answer', js: true do
    within '.answers' do
      click_on 'Edit'
      click_on 'add link'

      fill_in 'Link name', with: 'My google'
      fill_in 'URL', with: 'invalid link'

      click_on 'Save'

      expect(page).to have_link link.name, href: link.url
      expect(page).not_to have_link 'My google', href: google_url
    end
  end

  scenario 'User adds multiple new links to answer', js: true do
    within '.answers' do
      click_on 'Edit'
      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My gist'
        fill_in 'URL', with: gist_url
      end

      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My google'
        fill_in 'URL', with: google_url
      end


      click_on 'Save'

      expect(page).to have_link link.name, href: link.url
      expect(page).to have_link 'My google', href: google_url
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end
