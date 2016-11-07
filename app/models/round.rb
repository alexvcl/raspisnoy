class Round < ApplicationRecord
  enum status: [:not_started, :in_progress, :completed]

  enum format_type: [:common, :trumpless, :dark, :minimality, :golden]
  enum trump:       [:heart, :diamond, :club, :spade]

  belongs_to :game

  delegate :setting, to: :game, allow_nil: true

  validates :cards_served, presence: true
  validates :cards_served, length: { in: 1..9 }

  def reward
    setting[self.format_type]

    #todo no setting exception
  end


end