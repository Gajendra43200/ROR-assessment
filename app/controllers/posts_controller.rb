# frozen_string_literal: true

# posts controller
class PostsController < ApiController
  load_and_authorize_resource
  before_action :find_user, except: [:index]
  before_action :find_and_authorize_post, only: %i[update destroy]
  def index
    @user = User.find_by(id: params[:user_id])
    @posts = @user.posts
    @posts = filter_posts(@posts)
    @posts = search_posts(@posts)
    @posts = sort_posts(@posts)
    if @posts.present?
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(5)
      render json: @posts, meta: { current_page: @posts.current_page, total_page: @posts.total_pages },
             each_serializer: PostSerializer
    else
      render json: { message: 'post not exists for  this  user' }
    end
  end

  def create
    @blog = current_user.blogs.find(params[:blog_id])
    @post = @blog.posts.create!(post_params)
    if @post.save
      render json: PostSerializer.new(@post).serializable_hash, status: :created
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      render json: PostSerializer.new(@post).serializable_hash.merge(message: 'post updated successfuly'),
             status: :ok
    else
      render json: { error: 'post not updated' }, status: :unprocessable_entity
    end
  end

  def show
    render json: { message: 'You are post is not present' } unless @post.present?
    render json: PostSerializer.new(@post).serializable_hash, status: :ok
  end

  def destroy
    if @post.destroy
      render json: { message: 'post deleted successfully' }, status: :ok
    else
      render json: { error: 'post not deleted' }, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = User.find_by(id: params[:user_id])
    render json: { error: 'User not found for this id' }, status: :not_found unless @user
    authorize_user
  end

  def find_and_authorize_post
    if @user.user_type == 'Author'
      @post = @user.posts.find_by(id: params[:id])
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

  def post_params
    params.permit(:title, :body, :image, :user_id)
  end

  def filter_posts(posts)
    posts = posts.where(title: params[:title]) if params[:title].present?

    posts = posts.where(author_id: params[:author_id]) if params[:author_id].present?

    posts
  end

  def search_posts(posts)
    if params[:search].present?
      posts = posts.where('title ILIKE ? OR body ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    end

    posts
  end

  def sort_posts(posts)
    sort_by = params[:sort_by] || 'created_at'
    sort_order = params[:sort_order] || 'desc'
    posts.order("#{sort_by} #{sort_order}")
  end
end
