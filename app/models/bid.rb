class Bid < ApplicationRecord

  belongs_to :player
  belongs_to :round

  delegate :name, to: :player, allow_nil: true, prefix: true

  # validates :player,
  #           :round,
  #           presence: true

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
        common_points_distribution
      when 'minimality'
        minimality_points_distribution
      when 'golden'
        golden_points_distribution
      else

    end
  end

  private

    def fold?
      return if round.minimality? or round.golden?
      ordered == 0
    end

    def common_points_distribution
      if ordered == trick
        ordered * round.trick_reward
      elsif ordered > trick
        -((ordered - trick) * round.shortage_penalty)
      elsif trick > ordered
        trick * round.over_defence_reward
      end
    end

    def minimality_points_distribution
      #todo special rule
      trick * round.trick_reward
    end

    def golden_points_distribution
      trick * round.trick_reward
    end

end