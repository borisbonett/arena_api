class ApplicationController < ActionController::API

  include Pagy::Backend

  before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id]) if @decoded
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    end

    render json: { error: 'No autorizado' }, status: :unauthorized unless @current_user
  end

  def require_admin
    unless @current_user&.admin?
      render json: { error: 'Acceso denegado. Se requieren permisos de Administrador.' }, status: :forbidden
    end
  end
end
