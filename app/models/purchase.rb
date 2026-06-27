class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # Todo con 'quantity' (con "t")
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  validate :product_must_be_available, on: :create

  before_validation :set_current_product_price, on: :create
  after_create :decrease_product_stock

  def product_must_be_available
    if product.nil? || product.stock <= 0
      errors.add(:product, "no está disponible, stock agotado.")
    elsif product.stock < self.quantity # Con "t"
      errors.add(:product, "no tiene suficiente stock disponible.")
    end
  end

  def decrease_product_stock
    product.decrement!(:stock, self.quantity) # Con "t"
  end

  private

  def set_current_product_price
    self.price = product.price if product.present?
  end
end