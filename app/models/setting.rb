class Setting < ApplicationRecord
  serialize :trick_rewards, HashWithIndifferentAccess
  store_accessor :trick_rewards, :common, :trumpless, :dark, :minimality, :golden
  # store :trick_rewards, accessors: [ :common, :trumpless, :dark, :minimality, :golden ], coder: JSON

  #todo trick_rewards keys postfix (_trick_reward)

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
      }.with_indifferent_access
      self.fold_reward         = 5
      self.over_defence_reward = 1
      self.shortage_penalty    = 10
      self.dark_penalty        = 100
    end

end