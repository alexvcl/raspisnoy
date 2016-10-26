class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :game
      t.references :players_batch

      t.string :name, null: false

      t.timestamps
    end

    add_foreign_key :players, :games
    add_foreign_key :players, :players_batches
  end
end
