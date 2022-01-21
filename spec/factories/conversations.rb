# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_conversations_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :conversation do
    user1_id { 1 }
    user2_id { 2 }
    state { 'open' }
  end
end
