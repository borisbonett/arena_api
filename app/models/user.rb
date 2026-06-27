class User < ApplicationRecord
  has_secure_password

  # Relación con fotos de Active Storage
  has_one_attached :avatar

  # Relaciones de negocio
  has_many :purchases, dependent: :destroy
  has_many :products, through: :purchases

  # Validaciones
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, inclusion: { in: %w[admin user] }
  validates :password, presence: true, length: { minimum: 6 }

  # Método para verificar si el usuario es admin
  def admin?
    role == 'admin'
  end

end
