class Game < ApplicationRecord

  belongs_to :user

  #todo size validation
  has_one :setting
  has_one :players_batch

  has_many :rounds
  has_many :players

  before_validation :add_setting

  validates :setting, presence: true

  private

    def add_setting
      build_setting
    end

end