require 'features_helper'

feature 'User can sign up', %q{
  In order to ask questions
} do

  background { visit new_user_registration_path }

  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'tries to sign up' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    # expect(page).to have_content 'You have signed up successfully.'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'\
      ' Please follow the link to activate your account.'
  end
end
