# frozen_string_literal: true

# users controller
class UsersController < ApiController
  skip_before_action :authenticate_request, only: %i[create index]
  before_action :find_and_authorize_user, only: %i[destroy show update]
  def index
    @users = User.all
    render json: @users
  end

  def create
    user = User.new(user_params)
    if user.save
      token = UsersController.new.jwt_encode(user_id: user.id)
      render json: UserSerializer.new(user).serializable_hash.merge(token:), status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy!
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { error: 'User not deleted' }
    end
  end

  def show
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash, status: :ok
    else
      render json: { error: 'User not updated' }
    end
  end

  private

  def find_and_authorize_user
    @user = User.find_by(id: params[:id])

    unless @user
      render json: { error: 'User not found for this id' }, status: :not_found
      return
    end

    return if @current_user.present? && @user == @current_user

    render json: { error: 'please enter your id' }, status: :unauthorized
  end

  def user_params
    params.permit(:username, :email, :password_digest, :user_type)
  end
end
