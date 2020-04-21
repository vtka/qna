require 'features_helper'

feature 'User can view list of earned badges', %q{
  In order to evaluate own contribution
  As an authenticated user
  I'd like to be able to see list of earned badges
} do

  given!(:user) { create(:user) }
  given!(:question_one) { create(:question, author: user) }
  given!(:question_two) { create(:question, author: user) }
  given!(:badge_one) { create(:badge, question: question_one, user: user) }
  given!(:badge_two) { create(:badge, question: question_two, user: user) }

  scenario 'Authenticated user sees list of his badges' do
    sign_in(user)
    visit badges_path

    expect(page).to have_content badge_one.name
    expect(page).to have_css("img[src*='image.png']")
    expect(page).to have_content badge_two.name
  end

end
