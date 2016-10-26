class CreatePlayersBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :players_batches do |t|
      t.references :game
    end

    add_foreign_key :players_batches, :games
  end
end
