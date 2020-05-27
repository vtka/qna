require 'sphinx_helper'

feature 'User can search for question', %q{
  As guest user
  I'd like to be able to search by attributes
  In order to find specific question  
} do

  scenario 'User searches for the question', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
       # код теста
    end
  end
end
