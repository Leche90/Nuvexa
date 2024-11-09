class Product < ApplicationRecord
  has_one_attached :image
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items
  has_many :product_pricing_histories

   # Scope for products added within the last 3 days (new products)
   scope :new_products, -> { where("created_at >= ?", 3.days.ago) }

   # Scope for products updated within the last 3 days (recently updated)
   scope :recently_updated, -> { where("updated_at >= ?", 3.days.ago) }

  validates :name, presence: true
  validates :description, presence: false
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, presence: false
end
