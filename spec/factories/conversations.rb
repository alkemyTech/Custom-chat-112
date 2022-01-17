# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    user1 { 1 }
    user2 { 2 }
    state { "open" }
  end
end
