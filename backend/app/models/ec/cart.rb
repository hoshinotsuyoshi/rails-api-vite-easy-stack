class Ec::Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_one :purchase, dependent: :destroy
end
