FactoryBot.define do
  factory :user do
    name                    { "Name" }
    image                   { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    password                { "00000000" }
    password_confirmation   { "00000000" }
    sequence(:email)        { Faker::Internet.email }
  end
end