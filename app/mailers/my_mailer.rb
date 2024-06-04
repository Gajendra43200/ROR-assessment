class MyMailer < ApplicationMailer
  def comments_on_post
    @post = params[:post]
    @user = params[:user]
    @comment = params[:comment]
    mail(to: @user.email, from: 'BlogHub', post: @post, comment: @comment, subject: 'user commented on your post')
  end

  def like_on_post
    @post = params[:post]
    @user = params[:user]
    mail(to: @user.email, from: 'BlogHub', post: @post, subject: 'user liked on your post')
  end
end
