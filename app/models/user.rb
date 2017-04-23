class User < ApplicationRecord

  has_many :games
  has_many :players

  validates :email, presence: true

  validates :email, uniqueness: true

  validates :email, email: true

  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :trackable,
         :validatable
  # :confirmable
  # :recoverable

end