class CreatePlayers < ActiveRecord::Migration[5.0]
  def self.up
    create_table :players do |t|
      t.belongs_to :user
      t.belongs_to :game

      t.string :name, null: false, default: ''
      t.string :avatar

      t.timestamps
    end
  end

end
