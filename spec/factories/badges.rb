FactoryBot.define do
  sequence :badge_name do |n|
    "Badge#{n}"
  end

  factory :badge do
    name { generate(:badge_name) }
    image { Rack::Test::UploadedFile.new('spec/support/files/image.png', 'image/png') }
  end

  trait :without_image do
    image { nil }
  end
end
