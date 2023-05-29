class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :name, :email, presence: :true , uniqueness: true
  validates :password, presence: :true
end
