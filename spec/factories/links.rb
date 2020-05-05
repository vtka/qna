FactoryBot.define do
  factory :link do
    name { "Katata Games" }
    url { "http://katatagames.com" }
  end

  trait :gist do
    url { "https://gist.github.com/dersnek/2880c576b8e5912b7c0b8ea6a6fcff82" }
  end
end
