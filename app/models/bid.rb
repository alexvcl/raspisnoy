class Bid < ApplicationRecord

  attr_accessor :dark_penalty

  # belongs_to :game
  belongs_to :player, inverse_of: :bids
  belongs_to :round,  inverse_of: :bids

  scope :successful_tricks_by_player, -> (game, player) {
    joins(:round).where({
                         player_id: player.id,
                         rounds: {
                             game_id: game.id,
                             status: Round.statuses['tricks_counted']
                         }
                        })
    .where(%q{trick = ordered}).count
  }

  delegate :name,    to: :player, allow_nil: true, prefix: true
  delegate :setting, to: :game, allow_nil: true, prefix: true

  validates :player,
            :round,
            presence: true

  after_create :force_darkness #, if: 'round.dark?'

  def calculate_score
    # return nil unless round.tricks_counted?

    if fold?
      if trick == 0
        return dark? ? round.fold_reward * 2 : round.fold_reward
      end
      return trick * round.over_defence_reward if trick > 0
    end

    case round.format_type
      when 'common'
        common_points_distribution
      when 'trumpless'
        common_points_distribution
      when 'dark'
        dark_points_distribution
      when 'minimality'
        minimality_points_distribution
      when 'golden'
        golden_points_distribution
      else
    end
  end

  def add_dark_penalty(points)
    return points unless round.dark_for?(player)
    points - round.game_setting.dark_penalty
  end

  private

    def fold?
      return if round.minimality? or round.golden?
      ordered == 0
    end

    def common_points_distribution
      if ordered == trick
        points = ordered * round.trick_reward
        dark? ? points * 2 : points
      elsif ordered > trick
        -((ordered - trick) * round.shortage_penalty)
      elsif trick > ordered
        trick * round.over_defence_reward
      end
    end

    def dark_points_distribution
      points = if ordered == trick
        ordered * round.trick_reward
      elsif ordered > trick
        -((ordered - trick) * round.shortage_penalty)
      elsif trick > ordered
        trick * round.over_defence_reward
      end
      
      dark_penalty.present? ? add_dark_penalty(points): points
    end

    def minimality_points_distribution
      if round.bids.pluck(:trick).include?(9)
        trick == 9 ? 100 : -100
      else
        trick * round.trick_reward
      end
    end

    def golden_points_distribution
      trick * round.trick_reward
    end

    def force_darkness
      update_column(:dark, true) if round.dark?
    end

end