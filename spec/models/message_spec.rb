# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  detail          :string           not null
#  modified        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_deleted_at       (deleted_at)
#  index_messages_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user1) {create(:user)}
  let(:user2) {create(:user, email:'abcd@abcd.com')}
  let(:conversation) {create(:conversation, user1_id: user1.id, user2_id: user2.id)}

  subject(:message) { create(:message, user_id: user1.id, conversation_id: conversation.id) }

  context 'when create' do
    it 'has a detail field' do
      message.detail = nil
      expect(message).not_to be_valid
    end

    it 'has a user id (sender)' do
      message.user_id = nil
      expect(message).not_to be_valid
    end

    it 'has a conversation id' do
      message.conversation_id = nil
      expect(message).not_to be_valid
    end

    it 'saves into db when all params are present' do
      expect(message).to be_valid
    end
  end
end
