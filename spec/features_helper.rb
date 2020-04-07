# frozen_string_literal: true

require "rails_helper"
require "selenium/webdriver"

Capybara.register_driver :headless_chrome do |app|
  opts = Selenium::WebDriver::Chrome::Options.new
  opts.add_argument("--headless")
  opts.add_argument("--disable-gpu")
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: opts
  )
end

Capybara.javascript_driver = :headless_chrome

Capybara.configure do |config|
  config.enable_aria_label = true
end

RSpec::Matchers.define_negated_matcher :not_change, :change
