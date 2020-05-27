require 'features_helper'

feature 'User can sign in via social networks', %q{
  In order to simplify sign in process
  As an unauthenticated and authenticated user
  I'd like to be able to sign in with my social network accounts
 } do

  describe 'New user' do
    background { visit new_user_session_path }

    describe 'tries to sign in via GitHub' do
      scenario 'with valid credentials', js: true do
        oauth_response(provider: :github)
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'with invalid credentials', js: true do
        OmniAuth.config.mock_auth[:github] = :invalid
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub'
      end
    end

    describe 'tries to sign in via Facebook' do
      scenario 'with email provided via Facebook', js: true do
        oauth_response(provider: :facebook)
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account.'
      end

      scenario 'without email provided via Facebook', js: true do
        email = build(:user).email

        oauth_response(provider: :facebook, skip_email: true)
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Confirm email'

        fill_in 'user_email', with: email
        click_on 'Send confirmation instructions'

        expect(page).to have_content "Confirmation instructions sent to #{email}"

        open_email(email)
        current_email.click_link 'Confirm my account'

        page.document.synchronize do
          if page.current_path == root_path
            expect(page).to have_content 'Your email address has been successfully confirmed.'
            # expect(page).to have_content email
          end
        end
      end
    end
  end

  describe 'Existing user' do
    given!(:user) { create(:user, email: 'user1@example.com') }

    background { visit new_user_session_path }

    describe 'tries to sign in via GitHub' do
      scenario 'with valid credentials', js: true do
        oauth_response(provider: :github)
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'with invalid credentials', js: true do
        OmniAuth.config.mock_auth[:github] = :invalid
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub'
      end
    end

    scenario 'tries to sign in via Facebook', js: true do
      oauth_response(provider: :facebook)
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end
end
