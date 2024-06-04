# frozen_string_literal: true

# likes controller
class LikesController < ApiController
  load_and_authorize_resource
  before_action :find_user
  before_action :find_and_authorize_post, only: %i[create index]
  def create
    @likes = @post.likes.build(like_params)
    if @likes.save
      send_email_to_user(@post, @user)
    else
      render json: { error: errors.full_messages }
    end
  end

  def index
    @likes = @post.likes
    if @likes.present?
      render json: @likes
    else
      render json: { message: 'likes not exits for this post' }
    end
  end

  private

  def send_email_to_user(post, user)
    MyMailer.with(post:, user:).like_on_post.deliver_now
    render json: { message: 'post liked' }
  end

  def find_user
    @user = User.find_by(id: params[:user_id])
    if @user.present?
      authorize_user
    else
      render json: { error: 'User not found for this id' }, status: :not_found
    end
  end

  def find_and_authorize_post
    if @user.user_type == 'Author' || @user.user_type == 'Reader'
      @post = Post.find_by(id: params[:post_id])
      render json: { error: 'post not exits for this user id ' }, status: :not_found unless @post
      authorize_user
    else
      render json: { message: 'You are not auhorized' }, status: :not_found unless @post
      authorize_user
    end
  end

  def authorize_user
    return if @current_user.present? && @user == @current_user

    render json: { error: 'please enter login user id' }, status: :unauthorized
  end

  def like_params
    params.permit(:like, :user_id)
  end
end
