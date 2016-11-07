class Player < ApplicationRecord

  has_and_belongs_to_many :games

  has_many :bids

  validates :email, presence: true

  validates :email, uniqueness: true

  validates :email, email: true

  validates :name, presence: true

  validates :name, uniqueness: true

  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :trackable,
         :validatable
  # :confirmable
  # :recoverable

end