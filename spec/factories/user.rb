# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    username { Faker::Name.name }
    email { Faker::Name.name }
    password_digest { Faker::Internet.password }
    user_type { 'Author' }
  end
end
