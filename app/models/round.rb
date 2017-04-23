class Round < ApplicationRecord
  enum status: [:betting, :in_progress, :tricks_counted]

  enum format_type: [:common, :trumpless, :dark, :minimality, :golden]
  enum trump:       ['♥ heart', '♦ diamond', '♣ club', '♠ spade']

  attr_accessor :orders_sum

  belongs_to :game

  has_many :bids
  has_many :scores
  # has_many :players, through: :game

  accepts_nested_attributes_for :bids

  delegate :setting, to: :game, allow_nil: true

  validates :cards_served, presence: true
  validates :cards_served, length: { in: 1..9 }

  validate :allowed_bids_count
  validate :allowed_orders, unless: 'minimality? or golden?' #, if: Proc.new { |r| r.status_changed?(from: 'betting', to: 'in_progress') }

  # validate :tricks_integrity, if: Proc.new { |r| r.status_changed?(from: 'in_progress', to: 'tricks_counted') && bids.map(&:changed?).any? }
  validate :tricks_integrity, unless: Proc.new { |r| r.bids.map(&:trick).inject(:+).to_i.zero? }

  #todo status changes chain validation ?

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

  def add_scores!
    bids.each do |bid|
      bid.player.scores.create(round: self, points: bid.calculate_score)
    end
  end

  def ordered(player)
    return '' unless (in_progress? or tricks_counted?) or player
    bids.where(player_id: player.id).first.andand.ordered
  end

  def trick(player)
    return '' unless tricks_counted? or player
    bids.where(player_id: player.id).first.andand.trick
  end

  def trick_score(player)
    return '' unless tricks_counted? or player
    scores.where(player_id: player.id).first.andand.points
  end

  private

    def allowed_bids_count
      errors.add(:bids, 'cannot bid anymore') if bids.size > game.players.count
    end

    def tricks_integrity
      puts '===trick_integrity'
      puts bids.inspect
      # puts changes.inspect
      puts bids.map(&:trick).inject(:+)
      puts '===trick_integrity'
      errors.add(:bids, 'tricks sum is not correct') unless bids.map(&:trick).inject(:+) == cards_served
    end

    def allowed_orders
      puts 'ALLOWED ORDERS!!!'
      puts format_type
      puts bids.map(&:ordered).inject(:+)
      errors.add(:bids, 'orders sum cannot equal served cards count') if bids.map(&:ordered).inject(:+) == cards_served
    end

    def add_bids
      puts '----=!!!!!!!'
      puts '----=!!!!!!!'
      puts '----=!!!!!!!'
      game.players do |player|
        bids.create(player: player, ordered: 0)
      end
    end

end