# frozen_string_literal: true

# users controller
class BlogsController < ApiController
  before_action :authenticate_request, except: [:index]
  before_action :find_and_authorize_user, only: [:create]

  def index
    @blogs = Blog.all
    render json: @blogs
  end

  def show
    @blog = Blog.find(params[:id])
    render json: @blog
  end

  def create
    @blog = current_user.blogs.build(blog_params)
    if @blog.save
      render json: @blog, status: :created
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  def update
    @blog = current_user.blogs.find(params[:id])
    if @blog.update(blog_params)
      render json: @blog
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @blog = current_user.blogs.find(params[:id])
    @blog.destroy
    render json: 'blog deleted'
  end

  private

  def blog_params
    params.permit(:title)
  end

  def find_and_authorize_user
    @user = User.find_by(id: params[:id])

    unless @user
      render json: { error: 'User not found for this id' }, status: :not_found
      return
    end

    return if @current_user.present? && @user == @current_user

    render json: { error: 'please enter login user id' }, status: :unauthorized
  end
end
