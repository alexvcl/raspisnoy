class Game < ApplicationRecord
  enum status: [:setup_in_progress, :setup_done, :in_progress, :finished]

  has_and_belongs_to_many :players

  has_one :setting

  has_many :rounds

  belongs_to :current_round, class_name: 'Round', foreign_key: :current_round_id

  scope :by_player, -> (player) { includes(:players).where(players: {id: player.id}) }

  before_validation :add_setting,
                    :setup_default_rounds,
                    on: :create

  validates :players, length: {in: 1..2}, if: Proc.new { |game| game.players.any? }

  validates :rounds, length: {is: 36}

  with_options if: :setup_done? do |game|
    game.validates :setting, presence: true
    # game.validates :setting, length: {is: 1}
  end

  # after_update :start_first_round, if: Proc.new { |game|
  #   game.status_changed?(from: 'setup_in_progress', to: 'setup_done')
  # }

  # after_validation do
  #   puts rounds.size
  #   # puts rounds.map(&:cards_served)
  #   puts errors.full_messages
  # end

  #todo set current round on status change (setup_done?)

  def name
    description || l(created_at)
  end

  def start_first_round
    in_progress!
    update_attribute(:current_round_id, rounds.first.id)
    current_round.in_progress!
  end

  private

    def add_setting
      build_setting
    end

    def setup_default_rounds
      1.upto(8) { |i| rounds.build({format_type: :common, cards_served: i}) }

      4.times { rounds.build({format_type: :common, cards_served: 9}) }

      8.downto(1) { |i| rounds.build({format_type: :common, cards_served: i}) }

      4.times { rounds.build({format_type: :trumpless, cards_served: 9}) }
      4.times { rounds.build({format_type: :dark, cards_served: 9}) }
      4.times { rounds.build({format_type: :minimality, cards_served: 9}) }
      4.times { rounds.build({format_type: :golden, cards_served: 9}) }
    end

end