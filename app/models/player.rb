class Player < ApplicationRecord

  has_and_belongs_to_many :games

  belongs_to :user
  belongs_to :game

  has_many :bids
  has_many :scores

  validates :name, presence: true

  validates :name, uniqueness: true

  def score(game)
    # game.rounds.tricks_counted.
  end

  def successful_tricks_by_game(game)
    Bid.successful_tricks_by_player(game, self)
  end

end