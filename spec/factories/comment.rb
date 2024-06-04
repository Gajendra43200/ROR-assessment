# frozen_string_literal: true

FactoryBot.define do
  factory :comment, class: 'Comment' do
    body { Faker::Name.name }
    association :user
    association :post
  end
end
