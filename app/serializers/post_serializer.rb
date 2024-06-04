class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :timestamps, :author_name, :image
  def image
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) if object.image.attached?
  end

  def timestamps
    object.created_at
  end

  def author_name
    object.user.username
  end
end
