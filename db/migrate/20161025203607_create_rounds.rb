class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.belongs_to :game, index: true

      t.integer :status,       null: false, default: 0
      t.integer :format_type,  null: false, default: 0
      t.integer :trump,        null: false, default: 0
      t.integer :cards_served, null: false, default: 1

      t.timestamps
    end

    add_foreign_key :games, :rounds, column: :current_round_id
  end
end
