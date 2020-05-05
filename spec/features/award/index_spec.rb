require 'rails_helper'

feature 'User can view list of received awards', %q{
  In order to evaluate my contribution
  As an authenticated user
  I'd like to be able to see list of recieved awards
} do

  given!(:user) { create(:user) }
  given!(:question_one) { create(:question, author: user) }
  given!(:question_two) { create(:question, author: user) }
  given!(:award_one) { create(:award, question: question_one, recipient: user) }
  given!(:award_two) { create(:award, question: question_two, recipient: user) }

  scenario 'Authenticated user sees list of his awards' do
    sign_in(user)
    visit awards_path

    expect(page).to have_content award_one.title
    expect(page).to have_link award_one.question.title, href: question_path(award_one.question)
    expect(page).to have_css("img[src*='image.png']")
    expect(page).to have_content award_two.title
    expect(page).to have_link award_two.question.title, href: question_path(award_two.question)
  end
end
