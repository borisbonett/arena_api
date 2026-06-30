class Api::V1::ProductsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]
  before_action :require_admin, only: [:create, :update, :destroy]
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /api/v1/products (Público)
  def index
    @pagy, @products = pagy(Product.all.order(created_at: :desc))

    # Mapeamos cada producto usando tu método auxiliar 'product_with_image'
    products_json = @products.map { |product| product_with_image(product) }

    render json: {
      products: products_json,
      pagy: pagy_metadata(@pagy)
    }
  end

  # GET /api/v1/products/:id (Público)
  def show
    render json: product_with_image(@product), status: :ok
  end

  # POST /api/v1/products (Solo Admin)
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: product_with_image(@product), status: :created
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/v1/products/:id (Solo Admin)
  def update
    # Corrección opcional: Es mejor validar el stock antes de hacer el update permanente
    if product_params[:stock].to_i < 0
      render json: { errors: ["El stock no puede ser menor a 0"] }, status: :unprocessable_entity
      return
    end

    if @product.update(product_params)
      render json: product_with_image(@product), status: :ok
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/products/:id (Solo Admin)
  def destroy
    @product.destroy
    render json: { message: 'Producto eliminado' }, status: :ok
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    # Cambiado :quantity por :stock para alinearse con tus campos del backend
    params.permit(:name, :price, :description, :image, :stock)
  end

  def product_with_image(product)
    product.as_json.merge(
      image_url: product.image.attached? ? rails_blob_url(product.image, only_path: true) : nil
    )
  end
end