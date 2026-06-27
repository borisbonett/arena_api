class Product < ApplicationRecord

  # Relación con fotos de Active Storage
  has_one_attached :image

  has_many :purchases
  has_many :users, through: :purchases

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }


end
