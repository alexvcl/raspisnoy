module RoundRewardsConcern

  extend ActiveSupport::Concern

  def trick_reward
    setting.send(format_type)
    #todo no setting exception
  end

  def fold_reward
    setting.fold_reward
  end

  def over_defence_reward
    setting.over_defence_reward
  end

  def shortage_penalty
    setting.shortage_penalty
  end

end