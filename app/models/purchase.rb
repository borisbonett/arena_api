class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :product_must_be_available, on: :create
  
  after_create :decrease_product_stock

  def product_must_be_available
    if product.nil? || product.stock <= 0
      errors.add(:product, "no está disponible, stock agotado.")
    end
  end

  def decrease_product_stock
    product.decrement!(:stock)
  end
  
end
