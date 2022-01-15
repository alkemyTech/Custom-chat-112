# frozen_string_literal: true

require 'rails_helper'
require 'byebug'
RSpec.describe 'api/v1/users', type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { valid_attributes.merge(email: '') }
  let(:valid_headers) {}

  describe 'GET /index' do
    context 'with params' do
      it 'return status code :ok response' do
        get api_v1_users_url, headers: valid_headers
        expect(response).to have_http_status(:ok)
      end

      it 'return empty data' do
        get api_v1_users_url, headers: valid_headers, as: :json
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].length).to eq(0)
      end

      it 'return length data equals 1' do
        user
        get api_v1_users_url, headers: valid_headers, as: :json
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].length).to eq(1)
      end

      it 'return data with attribute key' do
        user
        get api_v1_users_url, headers: valid_headers, as: :json
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].first).to have_key('attributes')
      end

      it 'return data with id attribute' do
        user
        get api_v1_users_url, headers: valid_headers, as: :json
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].first['attributes']).to have_key('id')
      end

      it 'return data with name attribute' do
        user
        get api_v1_users_url, headers: valid_headers, as: :json
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].first['attributes']).to have_key('name')
      end

      it 'return data with valid length attribute' do
        user
        get api_v1_users_url, headers: valid_headers, as: :json
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].first['attributes'].length).to eq(2)
      end
    end
  end

  describe 'POST /create' do
    let(:valid_post_request) do
      post api_v1_users_url,
           params: valid_attributes,
           headers: valid_headers,
           as: :json
    end

    context 'with valid parameters' do
      it 'response with :created http code' do
        valid_post_request
        expect(response).to have_http_status(:created)
      end

      it 'creates a new User' do
        expect do
          valid_post_request
        end.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        valid_post_request
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested user' do
        user
        patch api_v1_user_url(user),
              params: { name: 'NewUser' }, headers: valid_headers, as: :json
        user.reload
      end

      it 'renders a JSON response with the user' do
        existing_user = user
        patch api_v1_user_url(existing_user),
              params: { name: 'NewUser' }, headers: valid_headers, as: :json
        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'response a :ok http code' do
        existing_user = user
        patch api_v1_user_url(existing_user),
              params: { name: 'NewUser' }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'response an :unprocessable_entity http code' do
        existing_user = user
        patch api_v1_user_url(existing_user),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders a JSON response with errors for the user' do
        existing_user = user
        patch api_v1_user_url(existing_user),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      existing_user = user
      expect do
        delete api_v1_user_url(existing_user), headers: valid_headers, as: :json
      end.to change(User, :count).by(-1)
    end
  end
end
