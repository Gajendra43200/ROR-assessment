# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: 'Post' do
    title { Faker::Name.name }
    body { Faker::Name.name }
    association :user
    association :blog
  end
end
