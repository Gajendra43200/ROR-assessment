# frozen_string_literal: true

FactoryBot.define do
  factory :blog, class: 'Blog' do
    title { Faker::Name.name }
    association :user
  end
end
