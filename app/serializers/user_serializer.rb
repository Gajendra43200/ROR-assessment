class UserSerializer < ActiveModel::Serializer
  # attributes :id, :username, :email, :password_digest, :user_type
  attributes :id, :username, :email, :user_type, :otp_required

  # def author_name
  #   object.username
  # end
end
