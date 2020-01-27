FactoryBot.define do
  factory :user do
    email { 'default@mail.com' }
    password { '12345678' }
  end
end
