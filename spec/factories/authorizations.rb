# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    provider { 'Github' }
    uid { '12345' }
  end
end
