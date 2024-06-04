class User < ApplicationRecord
  validates :user_type, inclusion: { in: %w[Author Reader] }
  validates :email, presence: true, uniqueness: true
  has_many :blogs
  has_many :posts
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
