class UserEmail < ApplicationRecord
  belongs_to :user, inverse_of: :email
  alias_attribute :email, :email_address

  normalizes :email_address, with: -> e { e.strip.downcase }
  validates :email_address, uniqueness: true
  scope :verified, -> { where.not(confirmed_at: nil) }
end
