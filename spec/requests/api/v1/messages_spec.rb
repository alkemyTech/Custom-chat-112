# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'api/v1/messages', type: :request do
  let(:user1) { create(:user) }
  let(:conversation1) { create(:conversation, user1_id: user1.id) }
  let(:valid_attributes) { attributes_for(:message) }
  let(:invalid_attributes) { attributes_for(:message, email: '') }
  let(:valid_token) { { 'Authorization' => AuthTokenService.call(user1.id).to_s } }

  context 'with valid authorization token' do
    it 'creates a new message and renders a successful response' do
      post api_v1_conversation_messages_url(conversation1.id),
           params: valid_attributes,
           headers: valid_token, as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error for missing param' do
      post api_v1_conversation_messages_url(conversation1.id),
           params: invalid_attributes,
           headers: valid_token, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'without valid authorization token' do
    it 'returns an error for invalid or unexisting token' do
      post api_v1_conversation_messages_url(conversation1.id),
           params: valid_attributes,
           headers: {}, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end