class User < ApplicationRecord

  has_many :games

  validates :email, presence: true

  validates :email, uniqueness: true

  validates :email, email: true

  devise :database_authenticatable,
         :registerable
         # :confirmable
         # :recoverable,
         # stretches: 12

end