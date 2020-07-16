FactoryBot.define do
  factory :picture do
    user
    category
    image             { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
  end
end