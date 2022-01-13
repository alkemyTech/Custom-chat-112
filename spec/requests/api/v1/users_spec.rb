# frozen_string_literal: true

require 'rails_helper'
require 'byebug'
RSpec.describe 'api/v1/users', type: :request do
  let(:user) { create(:user) }
  let(:valid_headers) {}

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      existing_user = user
      expect do
        delete api_v1_user_url(existing_user), headers: valid_headers, as: :json
      end.to change(User, :count).by(-1)
    end
  end
end
