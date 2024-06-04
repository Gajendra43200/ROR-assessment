class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :body, :timestamps, :commentable_name

  def timestamps
    object.created_at
  end

  def commentable_name
    object.user.user_type
  end
end
