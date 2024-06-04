# frozen_string_literal: true

# comments controller
class CommentsController < ApiController
  load_and_authorize_resource
  before_action :find_user
  before_action :find_and_authorize_post, only: %i[update destroy create show index]
  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      send_email_to_user(@post, @user, @comment)

    else
      render json: { error: errors.full_messages }
    end
  end

  def index
    @comments = @post.comments
    if @comments.present?
      render json: @comments
    else
      render json: { message: 'comments not exits for this post' }
    end
  end

  def show
    @comment = @post.comments.find(params[:id])
    if @comment.present?
      render json: CommentSerializer.new(@comment).serializable_hash, status: :updated
    else
      render json: { message: 'comments not exits for this id' }
    end
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.update(comment_params)
      render json: CommentSerializer.new(@comment).serializable_hash, status: :updated
    else
      render json: { error: errors.full_messages }
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    render json: CommentSerializer.new(@comment).serializable_hash, status: :ok
  end

  private

  def send_email_to_user(post, user, comment)
    MyMailer.with(post:, user:, comment:).comments_on_post.deliver_now
    render json: CommentSerializer.new(@comment).serializable_hash, status: :created
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
      @post = @user.posts.find_by(id: params[:post_id])
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

  def comment_params
    params.permit(:body, :post_id, :user_id)
  end
end
