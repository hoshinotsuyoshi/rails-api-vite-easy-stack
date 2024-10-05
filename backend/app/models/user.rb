class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: -> e { e.strip.downcase }

  validates :email_address, uniqueness: true

  enum :onboarding_status, %w[
    before_verify_email_address
    before_set_own_password
    onboarded
  ].index_by(&:itself), suffix: 'status'
end
