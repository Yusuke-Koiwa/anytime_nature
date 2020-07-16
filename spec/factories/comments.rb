FactoryBot.define do
  factory :comment do
    user
    picture
    text { "hogehogehogehogehoge" }
  end
end