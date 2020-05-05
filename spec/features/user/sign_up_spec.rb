require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to create an account
} do

  scenario 'Unregistered user tries to sign up' do
    visit root_path
    click_on 'Sign in'
    click_on 'Create an account'

    fill_in 'user_email', with: 'user@test.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    click_on 'Create an account'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
