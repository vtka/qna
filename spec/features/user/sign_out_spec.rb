require 'rails_helper'

feature 'User can sign out', %q{
  In order to finish session
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
