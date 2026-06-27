class Product < ApplicationRecord

  # Relación con fotos de Active Storage
  has_one_attached :image

  has_many :purchases
  has_many :users, through: :purchases

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }


  validate :product_must_be_available, on: :create

  def product_must_be_available
    if product.nil? || product.quantity <= 0
      errors.add(:product, "no está disponible, stock agotado.")
    end
  end

  def decrease_product_quantity
    product.decrement!(:quantity)
  end
end
