class Api::V1::ProductsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]
  before_action :require_admin, only: [:create, :update, :destroy]
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /api/v1/products (Público)
  def index
    @products = Product.all
    render json: @products.map { |p| product_with_image(p) }, status: :ok
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
    # Permite recibir la foto del producto (`image`) desde el ordenador
    params.permit(:name, :price, :image)
  end

  def product_with_image(product)
    product.as_json.merge(
      image_url: product.image.attached? ? rails_blob_url(product.image, only_path: true) : nil
    )
  end
end