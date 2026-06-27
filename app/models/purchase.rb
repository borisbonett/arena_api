class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # 'quanity' es la columna de la tabla 'purchases' (el typo)
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :product_must_be_available, on: :create
  
  # Después de guardar con éxito el préstamo, descontamos el libro del inventario
  after_create :decrease_product_stock

  def product_must_be_available
    if product.nil? || product.stock <= 0
      errors.add(:product, "no está disponible, stock agotado.")
    end
  end

  def decrease_product_stock
    # decrement! baja el contador en 1 directamente en la base de datos de forma segura
    product.decrement!(:stock)
  end
  
end
