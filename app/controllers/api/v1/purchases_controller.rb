class Api::V1::PurchasesController < ApplicationController
  # POST /api/v1/buy (Cualquier usuario autenticado)
  skip_before_action :authorize_request, only: [:create]
  
  def create
    @purchase = @current_user.purchases.new(purchase_params)

    if @purchase.save
      render json: { message: 'Compra realizada con éxito', purchase: @purchase }, status: :created
    else
      render json: { errors: @purchase.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.permit(:product_id, :quantity)
  end
end