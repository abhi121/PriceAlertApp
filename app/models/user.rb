class User < ApplicationRecord

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/}
  validates :name, presence: true
  validates :password, length: { minimum: 6, maximum: 10}

  has_many :alerts, dependent: :destroy
end
