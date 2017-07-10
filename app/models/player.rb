class Player < ApplicationRecord

  has_and_belongs_to_many :games

  belongs_to :user, inverse_of: :players
  belongs_to :game, inverse_of: :players

  has_many :bids,   inverse_of: :player
  has_many :scores, inverse_of: :player

  validates :name, presence: true
  validates :name, uniqueness: true

  def successful_tricks_by_game(game)
    Bid.successful_tricks_by_player(game, self)
  end

end