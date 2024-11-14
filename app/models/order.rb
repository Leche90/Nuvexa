class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  has_one :payment
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address
end
