class Bid < ApplicationRecord

  attr_accessor :dark_penalty

  # belongs_to :game
  belongs_to :player
  belongs_to :round

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

  delegate :name, to: :player, allow_nil: true, prefix: true

  # validates :player,
  #           :round,
  #           presence: true

  after_create :force_dark, if: 'round.dark?'

  def calculate_score
    return nil unless round.tricks_counted?

    if fold?
      return round.fold_reward if trick == 0
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
    points - round.dark_penalty
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
      #todo special rule
      trick * round.trick_reward
    end

    def golden_points_distribution
      trick * round.trick_reward
    end

    def force_dark
      update_column(:dark, true)
    end

end