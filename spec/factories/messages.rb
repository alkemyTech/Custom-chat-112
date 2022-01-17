# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    user_id { 1 }
    detail { 'Hello, how are you?' }
    modfied { false }
  end
end
