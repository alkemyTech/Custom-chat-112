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
#  settings        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users
  has_many :messages, dependent: :destroy

  attribute :is_admin, :boolean, default: false

  validates :is_admin, inclusion: { in: [true, false] }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
