# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'api/v1/messages', type: :request do
  let(:user1) { create(:user) }
  # let(:conversation1) { create(:conversation, user1_id: user1.id) }
  let(:valid_attributes) { attributes_for(:message) }
  let(:invalid_attributes) { attributes_for(:message, email: '') }
  let(:valid_token) { { 'Authorization' => AuthTokenService.call(user1.id).to_s } }

  let(:conversation_any) { create(:conversation) }
  let(:user2) { create(:user) }
  let(:message1_user1) { create(:message, user: user1, conversation: conversation_any) }
  let(:message2_user1) { create(:message, user: user1, conversation: conversation_any) }

  # context 'with valid authorization token' do
  #   it 'creates a new message and renders a successful response' do
  #     post api_v1_conversation_messages_url(conversation1.id),
  #          params: valid_attributes,
  #          headers: valid_token, as: :json
  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns an error for missing param' do
  #     post api_v1_conversation_messages_url(conversation1.id),
  #          params: invalid_attributes,
  #          headers: valid_token, as: :json
  #     expect(response).to have_http_status(:unprocessable_entity)
  #   end
  # end

  # context 'without valid authorization token' do
  #   it 'returns an error for invalid or unexisting token' do
  #     post api_v1_conversation_messages_url(conversation1.id),
  #          params: valid_attributes,
  #          headers: {}, as: :json
  #     expect(response).to have_http_status(:unauthorized)
  #   end
  # end

  context 'with valid authorization token in update' do
    it 'updates the requested message' do
      message1_user1
      patch api_v1_user_url(message1_user1),
            params: { detail: 'update message' }, headers: valid_token, as: :json
      message1_user1.reload
    end

    it 'response a :ok http code' do
      message1_user1
      patch api_v1_message_url(message2_user1),
            params: valid_attributes, headers: valid_token, as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'response a :unproccesable_entity http code, is not last message ' do
      message1_user1
      message2_user1
      patch api_v1_message_url(message1_user1),
            params: valid_attributes, headers: valid_token, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
