class Setting < ApplicationRecord

  belongs_to :game

  before_validation :default_settings

  private

    def default_settings
      self.trick_rewards = {
        'common': 10,
        'trumpless': 10,
        'dark': 10,
        'minimality': -10,
        'golden': 20
      }
      self.fold_reward         = 5
      self.over_defence_reward = 1
      self.shortage_penalty    = 10
    end

end