class Player < ApplicationRecord

  belongs_to :game
  belongs_to :players_batch

  validates :name, presence: true

end