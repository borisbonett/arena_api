class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  def login

    # logger.info "--- MIS PARÁMETROS: #{params.inspect} ---"

    if params[:email].blank? || params[:password].blank?
      return render json: { error: 'El correo y la contraseña son obligatorios' }, status: :bad_request
    end

    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Rails.env.development? ? 24.hours.from_now : 2.hours.from_now
      render json: { token: token, exp: time.strftime("%Y-%m-%d %H:%M"), role: @user.role, username: @user.name }, status: :ok
    else
      render json: { error: 'Credenciales incorrectas' }, status: :unauthorized
    end
  end
end