class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :name, :email, :password, presence: :true , uniqueness: true
end
