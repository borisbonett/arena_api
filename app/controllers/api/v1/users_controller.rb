class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :require_admin, only: [:index, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authorize_user_or_admin, only: [:update, :show]

  # GET /api/v1/users (Solo Admin)
  def index
    @users = User.all
    render json: @users.map { |u| user_with_avatar(u) }, status: :ok
  end

  # GET /api/v1/users/:id
  def show
    render json: user_with_avatar(@user), status: :ok
  end

  # POST /api/v1/auth/register (Público)
  def create
    @user = User.new(user_params)
    @user.role = 'user' # Forzar que se cree como usuario normal por defecto
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: user_with_avatar(@user), token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /api/v1/users/:id
  def update
    # Si no es admin, prevenir que se promueva a sí mismo a admin
    payload = user_params
    payload.delete(:role) unless @current_user.admin?

    if @user.update(payload)
      render json: user_with_avatar(@user), status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:id (Solo Admin)
  def destroy
    @user.destroy
    render json: { message: 'Usuario eliminado exitosamente' }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # Permite recibir la foto (`avatar`) subida desde el ordenador (multipart/form-data)
    params.permit(:name, :email, :password, :password_confirmation, :role, :avatar)
  end

  def authorize_user_or_admin
    unless @current_user.admin? || @current_user.id == @user.id
      render json: { error: 'No tienes permisos para interactuar con este perfil' }, status: :forbidden
    end
  end

  def user_with_avatar(user)
    user.as_json(except: :password_digest).merge(
      avatar_url: user.avatar.attached? ? rails_blob_url(user.avatar, only_path: true) : nil
    )
  end
end