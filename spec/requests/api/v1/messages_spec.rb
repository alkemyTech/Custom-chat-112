# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'api/v1/messages', type: :request do
  let(:user1) { create(:user) }
  let(:conversation1) { create(:conversation, user1_id: user1.id) }
  let(:valid_attributes) { attributes_for(:message) }
  let(:invalid_attributes) { attributes_for(:message, email: '') }
  let(:valid_token) { { 'Authorization' => AuthTokenService.call(user1.id).to_s } }

  let(:user2) { create(:user, email: 'user2@user2.com') }
  let(:conversation_any) { create(:conversation) }
  let(:message_user1) { create(:message, user: user1, conversation: conversation_any) }
  let(:valid_token_user2) { { 'Authorization' => AuthTokenService.call(user2.id).to_s } }

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

  context 'with valid authorization token in show' do
    it 'return status code ok' do
      get "/api/v1/messages/#{message_user1.id}", headers: valid_token
      expect(response).to have_http_status(:ok)
    end

    it 'return length params equal 8 for owner message' do
      get "/api/v1/messages/#{message_user1.id}", headers: valid_token
      parse_body = JSON.parse(response.body)
      expect(parse_body['data'].length).to eq(8)
      expect(response).to have_http_status(:ok)
    end

    it 'return length params equal 1 for not owner message' do
      get "/api/v1/messages/#{message_user1.id}", headers: valid_token_user2
      parse_body = JSON.parse(response.body)
      expect(parse_body['data']['attributes'].length).to eq(1)
      expect(response).to have_http_status(:ok)
    end
  end
end
