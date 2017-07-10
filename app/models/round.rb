class Round < ApplicationRecord
  include RoundRewardsConcern

  enum status:      [:betting, :in_progress, :tricks_counted]
  enum format_type: [:common, :trumpless, :dark, :minimality, :golden]

  # todo remove form trump keys
  enum trump:       ['♥ heart', '♦ diamond', '♣ club', '♠ spade']

  #todo
  # attr_accessor :jokers

  belongs_to :game, inverse_of: :rounds
  belongs_to :dealer, class_name: 'Player', foreign_key: 'dealer_id'

  has_many :bids, -> { order(player_id: :asc) }, inverse_of: :round, dependent: :destroy
  has_many :scores, inverse_of: :round, dependent: :destroy
  # has_many :players, through: :game

  accepts_nested_attributes_for :bids

  scope :by_format_and_served, -> (format, served) { where({format_type: format, cards_served: served}) }

  delegate :setting, :players, to: :game, allow_nil: true

  validates :cards_served, presence: true
  validates :cards_served, length: { in: 1..9 }
  validates :jokers,       length: {in: 0..2}

  validate :allowed_bids_count
  validate :allowed_orders,       unless: 'minimality? or golden?' #, if: Proc.new { |r| r.status_changed?(from: 'betting', to: 'in_progress') }
  validate :allowed_order_by_bid, if: :betting?
  validate :orders_positive,      if: :betting?

  # validate :tricks_integrity, if: Proc.new { |r| r.status_changed?(from: 'in_progress', to: 'tricks_counted') && bids.map(&:changed?).any? }
  validate :tricks_integrity, unless: Proc.new { |r| r.bids.map(&:trick).inject(:+).to_i.zero? }

  after_update :handle_jokers

  #todo status changes chain validation ?

  def jokers
    @jokers || []
  end

  def add_scores!
    bids.each do |bid|
      bid.player.scores.create(round: self, points: bid.calculate_score)
    end
  end

  def ordered(player)
    return '' if betting? or (not player)
    # bids.where(player_id: player.id).first.andand.ordered
    Bid.where({player_id: player.id, round_id: id}).first.andand.ordered
  end

  def trick(player)
    return '' unless tricks_counted? and player
    # bids.where(player_id: player.id).first.andand.trick
    Bid.where({player_id: player.id, round_id: id}).first.andand.trick
  end

  def trick_score(player)
    return '' unless tricks_counted? and player
    # scores.where(player_id: player.id).first.andand.points
    Score.where({player_id: player.id, round_id: id}).first.andand.points
  end

  def dark_for?(player)
    # return false unless (in_progress? and dark?) and player
    return false unless (common? or trumpless? or dark?) and (in_progress? or tricks_counted?) and player
    # bids.where(player_id: player.id).first.andand.dark?
    Bid.where({player_id: player.id, round_id: id}).first.andand.dark?
  end

  private

    def allowed_bids_count
      errors.add(:bids, 'cannot bid anymore') if bids.size > game.players.count
    end

    def tricks_integrity
      errors.add(:bids, 'tricks sum is not correct') unless bids.map(&:trick).inject(:+) == cards_served
    end

    def allowed_orders
      errors.add(:bids, 'orders sum cannot equal served cards count') if bids.map(&:ordered).inject(:+) == cards_served
    end

    def orders_positive
      bids.each do |bid|
        errors.add(:bids, "#{bid.player.name} ty ahuel?") if bid.ordered < 0
      end
    end

    def allowed_order_by_bid
      bids.each do |bid|
        errors.add(:bids, "#{bid.player.name} ty ahuel?") if bid.ordered > cards_served
      end
    end

    def handle_jokers

    end

end