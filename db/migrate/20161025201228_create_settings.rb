class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.references :game

      t.json :trick_rewards, null: false, default: {}

      t.integer :fold_reward,         null: false, default: 5
      t.integer :over_defence_reward, null: false, default: 1
      t.integer :shortage_penalty,    null: false, default: 10

      t.timestamps
    end

    add_foreign_key :settings, :games
  end
end
