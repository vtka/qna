FactoryBot.define do
  sequence :award_title do |n|
    "Award#{n}"
  end

  factory :award do
    title { generate(:award_title) }
    image { Rack::Test::UploadedFile.new('spec/support/files/image.png', 'image/png') }
  end

  trait :without_image do
    image { nil }
  end
end
