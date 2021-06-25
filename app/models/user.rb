class User < ApplicationRecord
  has_many :members
  has_secure_password
  before_save { self.username = username.downcase }
  validates :username, presence: true, length: {minimum: 3}, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
end
