# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
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
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_presence_of(:email) }

    describe 'must save' do
      subject(:user) { create(:user) }

      it 'when good params provided' do
        expect(user).to be_valid
      end
    end
  end
end
