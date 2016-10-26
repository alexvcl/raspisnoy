class PlayersBatch < ApplicationRecord

  belongs_to :game

  has_many :players

  accepts_nested_attributes_for :players #, reject_if:  proc { |attributes| }

  validates :game, presence: true

end