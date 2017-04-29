class Game < ApplicationRecord
  enum status: [:setup_in_progress, :setup_done, :in_progress, :finished]

  has_and_belongs_to_many :players, after_add: :add_player_dependent_round

  has_one :setting

  # has_many :bids
  has_many :rounds, -> { order(weight: :asc) }
  has_many :minimality_rounds, -> { where format_type: Round.format_types['minimality'] }, class_name: 'Round'
  has_many :golden_rounds, -> { where format_type: Round.format_types['golden'] }, class_name: 'Round'
    # "CASE
    #   WHEN cards_served = '1'::integer THEN '1'
    # END"

  belongs_to :user
  belongs_to :current_round, class_name: 'Round', foreign_key: :current_round_id

  accepts_nested_attributes_for :players

  scope :by_player, -> (player) { includes(:players).where(players: {id: player.id}) }

  before_validation :add_setting,
                    on: :create

  # validates :players, presence: true
  # validates :players, length: {in: 1..4}, if: Proc.new { |game| game.players.any? }

  with_options if: :setup_done? do |game|
    game.validates :setting, presence: true
    # game.validates :setting, length: {is: 1}
  end

  after_create :add_default_rounds

  after_update :add_dependent_round_bids, if: Proc.new { |g| g.status_changed?(from: 'setup_done', to: 'in_progress') }

  def name
    description || l(created_at)
  end

  def start!
    in_progress!
    update_attribute(:current_round_id, rounds.first.id)
  end

  def next_round!
    return if finished?
    next_round = rounds.where('id > ?', current_round.id).first
    if next_round.present?
      update_attribute(:current_round, rounds.where('id > ?', current_round.id).first)
    else
      finished!
    end
  end

  def rounds_complete?
    rounds.pluck(:status).map! {|s| s == 'tricks_counted'}.all?
  end

  def who_is_the_winner
    return unless rounds_complete?
    scores = {}
    players.each do |player|
      scores[player] = score_by(player)
    end
    scores.key(scores.values.max)
  end

  def score_by(player)
    player.scores.joins(:round).where(rounds: {game_id: 1}).sum(:points)
  end

  private

    def add_setting
      build_setting
    end

    def add_player_dependent_round(player)
      return unless persisted?

      rounds.create({format_type: :common, cards_served: 9, weight: 9})
      rounds.create({format_type: :minimality, status: :in_progress, cards_served: 9, weight: 35})
      rounds.create({format_type: :golden,  status: :in_progress, cards_served: 9, weight: 40})
    end

    def add_dependent_round_bids
      return unless players and persisted?

      minimality_rounds.each do |round|
        players.each {|player| round.bids.create({player: player, ordered: 0}) }
      end
      golden_rounds.each do |round|
        players.each {|player| round.bids.create({player: player, ordered: 0}) }
      end
    end

    def add_default_rounds
      1.upto(8) { |i| rounds.create({format_type: :common, cards_served: i, weight: i}) }
      8.downto(1) { |i| rounds.create({format_type: :common, cards_served: i, weight: 18 - i}) }

      4.times { rounds.create({format_type: :trumpless, cards_served: 9, weight: 25}) }
      4.times { rounds.create({format_type: :dark, cards_served: 9, weight: 30}) }
    end

end