class Game < ApplicationRecord
  enum status: [:setup_in_progress, :setup_done, :in_progress, :finished]

  has_and_belongs_to_many :players, after_add: :add_player_dependent_round

  has_one :setting

  # has_many :bids
  has_many :rounds,            -> { order(weight: :asc, created_at: :asc) }, dependent: :destroy
  has_many :minimality_rounds, -> { where format_type: Round.format_types['minimality'] }, class_name: 'Round'
  has_many :golden_rounds,     -> { where format_type: Round.format_types['golden'] }, class_name: 'Round'
    # "CASE
    #   WHEN cards_served = '1'::integer THEN '1'
    # END"

  belongs_to :user, inverse_of: :games
  belongs_to :current_round, class_name: 'Round', foreign_key: :current_round_id

  accepts_nested_attributes_for :players

  scope :by_player, -> (player) { includes(:players).where(players: {id: player.id}) }

  before_validation :add_setting, on: :create

  # validates :players, presence: true
  # validates :players, length: {in: 1..4}, if: Proc.new { |game| game.players.any? }

  with_options if: :setup_done? do |game|
    game.validates :setting, presence: true
    # game.validates :setting, length: {is: 1}
  end

  after_create :add_default_rounds

  after_update :add_dependent_round_bids,
               :set_round_dealers, 
               if: Proc.new { |g| g.status_changed?(from: 'setup_done', to: 'in_progress') }

  def name
    description || l(created_at)
  end

  def start!
    return unless setup_done?
    in_progress!
    update_attribute(:current_round, rounds.first)
  end

  def next_round!
    return if finished?
    next_round = rounds.where('weight > ?', current_round.weight).first
    if next_round.present?
      update_attribute(:current_round, next_round)
    else
      finished!
    end
  end

  def rounds_complete?
    # rounds.pluck(:status).map! {|s| s == 'tricks_counted'}.all?
    rounds.tricks_counted.count == rounds.count
  end

  #TODO as service
  def who_is_the_winner
    return unless rounds_complete?
    scores = {}

    puts '============='
    puts players.joins([:scores, :rounds]).where(rounds: {game_id: game.id}).select('SUM(scores.points)')
    puts '============='

    players.each do |player|
      scores[player] = score_by(player)
    end
    scores.key(scores.values.max)
  end

  def score_by(player)
    player.scores.joins(:round).where(rounds: {game_id: game.id}).sum(:points)
  end

  private

    def add_setting
      build_setting
    end

    def add_default_rounds
      1.upto(8)   { |i| rounds.create({format_type: :common, cards_served: i, weight: i}) }
      8.downto(1) { |i| rounds.create({format_type: :common, cards_served: i, weight: 25 - i}) }
    end

    def add_player_dependent_round(player)
      return unless persisted?

      rounds.create({format_type: :common, cards_served: 9, weight: (9 + rounds.by_format_and_served(Round.format_types['common'], 9).count)})
      rounds.create({format_type: :trumpless, cards_served: 9, weight: (30 + rounds.by_format_and_served(Round.format_types['trumpless'], 9).count)})
      rounds.create({format_type: :dark, cards_served: 9, weight: (40 + rounds.by_format_and_served(Round.format_types['dark'], 9).count)})
      rounds.create({format_type: :minimality, status: :in_progress, cards_served: 9, weight: (50 + minimality_rounds.count)})
      rounds.create({format_type: :golden,  status: :in_progress, cards_served: 9, weight: (60 + golden_rounds.count)})
    end

    def add_dependent_round_bids
      return unless players and persisted?

      players.each do |player|
        minimality_rounds.each {|round| round.bids.create({player: player, ordered: 0}) }
        golden_rounds.each     {|round| round.bids.create({player: player, ordered: 0}) }
      end
    end

    def set_round_dealers
      current_dealer = players.first

      rounds.each do |round|
        round.update_attribute(:dealer, current_dealer)

        if players.where("id > ?", current_dealer.id).first.present?
          current_dealer = players.where("id > ?", current_dealer.id).first
        else
          current_dealer = players.first
        end 
      end
    end 

end