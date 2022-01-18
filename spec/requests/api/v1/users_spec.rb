# frozen_string_literal: true

require 'rails_helper'
require 'byebug'
RSpec.describe 'api/v1/users', type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { valid_attributes.merge(email: '') }
  let(:valid_headers) {}
  let(:user_admin) { create(:user, is_admin: true, email: 'mail@mail.com') }
  let(:valid_admin_headers) { { 'Authorization' => AuthTokenService.call(user_admin.id).to_s } }
  let(:valid_user_headers) { { 'Authorization' => AuthTokenService.call(user.id).to_s } }

  describe 'GET /index' do
    context 'with params' do
      it 'return status code :ok response' do
        get api_v1_users_url, headers: valid_headers
        expect(response).to have_http_status(:ok)
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

  describe 'GET /show' do
    context 'with valid params for admin and not admin user' do
      it 'response with two attibutes for not admin user' do
        get api_v1_users_path(user.id), headers: valid_headers
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].first['attributes'].length).to eq(2)
        expect(response).to have_http_status(:ok)
      end

      it 'response with seven attibutes for admin user' do
        user
        get "/api/v1/users/#{user.id}", headers: valid_admin_headers, as: :json
        parse_body = JSON.parse(response.body)
        expect(parse_body['data'].length).to eq(7)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with valid params return status code unprocessable entity for any user' do
      it 'with unprocessable_entity status code for basic user' do
        get '/api/v1/users/100', headers: valid_user_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'with unprocessable_entity status code for admin user' do
        get '/api/v1/users/100', headers: valid_admin_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without valid header on details user' do
      it 'without valid header' do
        user
        get "/api/v1/users/#{user.id}", headers: valid_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /create' do
    let(:valid_post_request) do
      post api_v1_users_url,
           params: valid_attributes,
           as: :json
    end

    context 'with valid parameters' do
      it 'response with :created http code' do
        valid_post_request
        expect(response).to have_http_status(:ok)
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
