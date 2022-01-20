# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    user1_id { 1 }
    user2_id { 2 }
    state { 'open' }
  end
end
