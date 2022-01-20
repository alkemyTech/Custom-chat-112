# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  config          :string
#  email           :string           not null
#  is_admin        :boolean          default(FALSE)
#  name            :string           not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  context 'when create' do
    it 'has an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'has a password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'has a name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'saves with good params' do
      expect(user).to be_valid
    end
  end
end
